<?php

    /**
     * evasione della coda degli SMS in uscita
     *
     * Questo task invia un SMS della coda `sms_out` a ogni chiamata, con lo stesso schema a token del task gemello delle
     * mail ( `_src/_api/_task/_mail.queue.send.php` ): marca una riga con il proprio token, la legge, la passa al
     * provider e, se l'invio riesce, la sposta in `sms_sent`; se l'invio fallisce la riga resta in coda, `tentativi`
     * sale di uno e l'invio viene rimandato di tante ore quanti sono i tentativi fatti, fino al limite descritto più
     * sotto. Richiede il privilegio `GESTIONE_COMUNICAZIONI` ed è pensato per il cron ogni minuto con più iterazioni.
     *
     * modalità di evasione
     * ====================
     * La modalità si sceglie con i parametri della richiesta:
     *
     * parametro        | comportamento
     * -----------------|------------------------------------------------------------------------------------------
     * id=<id>          | invia l'SMS indicato anche se non è ancora il suo momento, purché nessun altro processo lo abbia già marcato; un SMS fermo per troppi tentativi riparte con i tentativi azzerati
     * hard=1           | invia il primo SMS della coda per `ordine` e `timestamp_invio`, ignorando la data prevista
     * full=1           | rimette in circolo tutta la coda: azzera `timestamp_invio` su tutte le righe, tranne quelle ferme per troppi tentativi, e non invia nulla, la coda la riprende il cron dal giro successivo
     * nessuno          | invia il primo SMS la cui data prevista è passata o assente
     *
     * Con `full=1` il task risponde con quanti SMS avevano una data prevista, ora azzerata ( `rimesse` ), quanti ne ha
     * sbloccati ( `sbloccate`, vedi sotto ) e quanti restano fermi per troppi tentativi ( `ferme` ). Fino al 2026-09-30
     * rispondeva "nessun SMS da evadere", che sembrava un errore.
     *
     * righe marcate e mai rilasciate
     * ==============================
     * Il task marca la riga con il proprio token e scrive in `timestamp_elaborazione` l'ora della marcatura, nello stesso
     * UPDATE; alla fine del giro il token si toglie. Se il processo muore a metà, la riga resterebbe marcata e nessuna
     * modalità la prenderebbe più: per questo all'inizio di ogni giro, in tutte le modalità, il task toglie il token
     * alle righe marcate da più di `$cf['sms']['minuti_sblocco']` minuti ( default 60, in `_src/_config/_540.sms.php` ),
     * che tornano in coda come le altre, come fa il task delle mail. Un SMS sbloccato così può partire due volte, se il
     * processo era morto dopo averlo consegnato al provider e prima di spostarlo fra gli inviati.
     *
     * server e provider
     * =================
     * Se la riga ha la colonna `server` valorizzata si usa `$cf['sms']['servers'][ <server> ]`, altrimenti il server del
     * profilo corrente, `$cf['sms']['server']`. Il `type` del server sceglie la funzione del provider: `skebby` chiama
     * skebbySend() ( `_src/_lib/_skebby.tools.php` ), `ehiweb` chiama ehiwebSend() ( `_src/_lib/_ehiweb.tools.php` ).
     * Un server nominato nella riga ma assente dalla configurazione, un profilo senza server o un tipo sconosciuto sono
     * un errore di invio come gli altri: l'SMS resta in coda, il tentativo si conta e l'errore va nel log `sms`.
     * Fino al 2026-09-29 il task del modulo `SM000.sms` in quel caso considerava l'SMS inviato e lo spostava fra gli
     * inviati senza che fosse mai partito.
     *
     * lo spostamento fra gli inviati
     * ==============================
     * La copia in `sms_sent` è un `REPLACE INTO sms_sent SELECT * FROM sms_out`, quindi le due tabelle devono avere le
     * stesse colonne nello stesso ordine. Se la copia fallisce l'SMS è già stato consegnato al provider: la riga NON
     * viene cancellata da `sms_out` e NON viene rimessa in coda, ma resta marcata con il token dedicato `COPIA_FALLITA`,
     * che la esclude da tutte le modalità di evasione ( anche da `id` ) e dallo sblocco delle righe abbandonate, e
     * l'errore va nel log `sms` a livello LOG_CRIT. Va sistemata a mano, allineando le tabelle e spostando la riga, o
     * cancellandola dalla scheda dell'SMS in uscita.
     *
     * Il task è la copia nel modulo `SM000.sms` del task del core `_src/_api/_task/_sms.queue.send.php`, come le mail
     * hanno la loro in `MA000.mail`: le due copie vanno tenute uguali, cambia solo l'inclusione del framework. Si chiama
     * come `/task/SM000.sms/sms.queue.send` ed è quello che usano gli strumenti del modulo.
     *
     * limite di tentativi
     * ===================
     * Quando i tentativi falliti arrivano a `$cf['sms']['tentativi_massimi']` ( default 10, in `_src/_config/_540.sms.php`;
     * con 0 il limite non c'è ) l'SMS non si riprova più: la riga resta in `sms_out` con i tentativi fatti e il token
     * dedicato `TROPPI_TENTATIVI`, e l'errore va nel log `sms` a livello LOG_ERR. Come `COPIA_FALLITA` il token la toglie
     * dal giro normale, da `hard=1` e dallo sblocco delle righe abbandonate, e `full=1` non la rimette in circolo, come
     * fa il task delle mail. Lo fa ripartire `id=<id>`, cioè l'invio forzato dalla scheda dell'SMS in uscita, che toglie
     * il token e azzera i tentativi prima di marcarlo: se fallisce ancora ricomincia il conteggio. Fino al 2026-09-30 un
     * SMS che falliva sempre veniva riprovato all'infinito.
     *
     * @file
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../../../../_src/_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_COMUNICAZIONI' );

    // inizializzo l'array del risultato
	$status = array();

    // status
	$status['info'][] = 'inizio evasione coda SMS';

    // log
	logWrite( 'richiesta di elaborazione della coda degli SMS in uscita', 'sms' );

    // chiave di lock
    if( ! isset( $status['token'] ) ) {
        $status['token'] = getToken( __FILE__ );
    }

    // sblocco degli SMS marcati e mai rilasciati
    // NOTA restano fuori le righe bloccate apposta dopo una copia fallita, che vanno sistemate a mano, e quelle ferme
    // per troppi tentativi, che riparte solo l'invio forzato di quella riga
    $status['sbloccate'] = mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE sms_out SET token = NULL, timestamp_elaborazione = NULL WHERE token IS NOT NULL AND token NOT IN ( ?, ? ) AND timestamp_elaborazione < ?',
        array(
            array( 's' => 'COPIA_FALLITA' ),
            array( 's' => 'TROPPI_TENTATIVI' ),
            array( 's' => strtotime( '-' . $cf['sms']['minuti_sblocco'] . ' minutes' ) )
        )
    );

    // log
    if( ! empty( $status['sbloccate'] ) ) {
        logWrite( 'sbloccati ' . $status['sbloccate'] . ' SMS marcati da più di ' . $cf['sms']['minuti_sblocco'] . ' minuti', 'sms', LOG_WARNING );
    }

	// modalità di evasione (specifico SMS, evasione forzata, evasione totale, evasione naturale)
	if( isset( $_REQUEST['id'] ) ) {

		// status
		$status['info'][] = 'evasione specifico messaggio in coda';

        // se la riga è ferma per troppi tentativi la rimetto in coda con i tentativi azzerati
        // NOTA è l'unico modo di farla ripartire: il giro normale, hard e full non la prendono
        $status['riprese'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE sms_out SET token = NULL, tentativi = 0 WHERE id = ? AND token = ?',
            array(
                array( 's' => $_REQUEST['id'] ),
                array( 's' => 'TROPPI_TENTATIVI' )
            )
        );

        // log
        if( ! empty( $status['riprese'] ) ) {
            logWrite( 'SMS #' . $_REQUEST['id'] . ' fermo per troppi tentativi rimesso in coda a mano, con i tentativi azzerati', 'sms' );
        }

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE sms_out SET token = ?, timestamp_elaborazione = ? WHERE id = ? AND token IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => time() ),
                array( 's' => $_REQUEST['id'] )
            )
        );

	} elseif( isset( $_REQUEST['hard'] ) ) {

		// status
		$status['info'][] = 'evasione forzata della coda';

		// token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE sms_out SET token = ?, timestamp_elaborazione = ? WHERE token IS NULL
                ORDER BY ordine ASC, timestamp_invio ASC LIMIT 1',
            array(
                array( 's' => $status['token'] ),
                array( 's' => time() )
            )
        );

	} elseif( isset( $_REQUEST['full'] ) ) {

		// status
		$status['info'][] = 'forzatura elaborazione totale della coda';

		// rimetto in circolo tutta la coda
        // NOTA le righe ferme per troppi tentativi restano ferme, le riparte solo l'invio forzato di quella riga
        $status['rimesse'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE sms_out SET timestamp_invio = NULL WHERE ( token IS NULL OR token <> ? )',
            array(
                array( 's' => 'TROPPI_TENTATIVI' )
            )
        );

        // conto le righe ferme per troppi tentativi
        $status['ferme'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT count( id ) FROM sms_out WHERE token = ?',
            array(
                array( 's' => 'TROPPI_TENTATIVI' )
            )
        );

		// status
		$status['info'][] = 'SMS con la data prevista azzerata: ' . intval( $status['rimesse'] ) . ', SMS sbloccati: ' . intval( $status['sbloccate'] ) . '; tutta la coda è inviabile e la riprende il cron dal prossimo giro, tranne gli SMS fermi per troppi tentativi: ' . intval( $status['ferme'] ) . ', che riparte solo l\'invio forzato dalla scheda';

		// log
		logWrite( 'coda degli SMS rimessa in circolo: ' . intval( $status['rimesse'] ) . ' date previste azzerate', 'sms' );

	} else {

		// status
		$status['info'][] = 'strategia standard di evasione della coda';

		// token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE sms_out SET token = ?, timestamp_elaborazione = ? WHERE ( timestamp_invio <= unix_timestamp() OR timestamp_invio IS NULL )
                AND token IS NULL
                ORDER BY ordine ASC, timestamp_invio ASC LIMIT 1',
            array(
                array( 's' => $status['token'] ),
                array( 's' => time() )
            )
        );

	}

	// prelevo un SMS dalla coda
	$sms = mysqlSelectRow(
		$cf['mysql']['connection'],
		'SELECT * FROM sms_out WHERE token = ?',
		array(
			array( 's' => $status['token'] )
		)
	);

	// se c'è almeno un SMS da inviare
	if( ! empty( $sms ) ) {

		// status
		$status['info'][] = 'trovato un SMS da evadere';

		// prelevo i dati del server
		// NOTA un server nominato nella riga ma assente da $cf['sms']['servers'] non ricade sul server di default:
		// resta NULL e finisce nel ramo default dello switch qui sotto, come un profilo senza server
		$server = (
			( ! empty( $sms['server'] ) )
			? ( $cf['sms']['servers'][ $sms['server'] ] ?? NULL )
			: $cf['sms']['server']
		);

		// mittente
		$mittente = unserialize( $sms['mittente'] ?? '' );

		// invio l'SMS
		switch( $server['type'] ?? NULL ) {

			case 'skebby':

				// NOTA skebbySend() riceve il mittente nella forma array( nome => numero ) e ne usa il numero, o il nome
				// se il numero è vuoto ( 2026-04-13, riallineamento da gimbe )
				$r = skebbySend(
					$sms['corpo'],
					unserialize( $sms['destinatari'] ?? '' ),
					$server['username'],
					$server['password'],
					$mittente
				);

			break;

			case 'ehiweb':

				// NOTA a Ehiweb si passa il nome del mittente, come ha sempre fatto questo task
				$r = ehiwebSend(
					$sms['corpo'],
					unserialize( $sms['destinatari'] ?? '' ),
					$server['username'],
					$server['password'],
					( ( is_array( $mittente ) ) ? array_key_first( $mittente ) : $mittente ),
					$server['id_api'] ?? NULL
				);

			break;

			default:

				// log
				logWrite( 'server ' . ( ( ! empty( $sms['server'] ) ) ? $sms['server'] : 'di default' ) . ' per l\'SMS #' . $sms['id'] . ' non configurato o di tipo non supportato: ' . ( $server['type'] ?? '(nessun tipo)' ), 'sms', LOG_ERR );

				// status
				$status['err'][] = 'server SMS non configurato o di tipo non supportato';

				// esito
				$r = false;

			break;

		}

		// controllo l'esito dell'invio
		if( $r !== false ) {

			// log
			logWrite( 'invio SMS #' . $sms['id'] . ' completato: ' . $r, 'sms' );

			// sposto l'SMS nella coda degli inviati
			$s1 = mysqlQuery(
				$cf['mysql']['connection'],
				'REPLACE INTO sms_sent SELECT * FROM sms_out WHERE token = ?',
				array(
					array( 's' => $status['token'] )
				)
			);

			// controllo l'esito dello spostamento
			// NOTA mysqlQuery() restituisce false se la query solleva un'eccezione, ma -1 ( le righe toccate da uno statement
			// fallito ) se l'esecuzione fallisce senza eccezione, come succede prima di PHP 8.1
			if( empty( $s1 ) || $s1 < 0 ) {

				// NOTA l'SMS è già partito: la riga resta nella sms_out con il token dedicato COPIA_FALLITA, che la toglie da
				// tutte le modalità di evasione e dallo sblocco delle righe abbandonate, così non viene né persa né inviata una
				// seconda volta
				mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE sms_out SET token = ? WHERE token = ?',
					array(
						array( 's' => 'COPIA_FALLITA' ),
						array( 's' => $status['token'] )
					)
				);

				// log
				logWrite( 'SMS #' . $sms['id'] . ' inviato ma non copiato nella sms_sent, resta nella sms_out bloccato dal token COPIA_FALLITA', 'sms', LOG_CRIT );

				// status
				$status['err'][] = 'SMS inviato ma non spostato fra gli inviati';

			} else {

				// log
				logWrite( 'spostamento SMS #' . $sms['id'] . ' dalla sms_out alla sms_sent completato', 'sms' );

				// aggiorno la timestamp di invio
				$s2 = mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE sms_sent SET timestamp_invio = ?, token = NULL, timestamp_elaborazione = NULL WHERE token = ?',
					array(
						array( 's' => time() ),
						array( 's' => $status['token'] )
					)
				);

				// log
				logWrite( 'timestamp di invio SMS #' . $sms['id'] . ' aggiornato', 'sms' );

				// elimino l'SMS inviato dalla coda degli SMS in uscita
				$s3 = mysqlQuery(
					$cf['mysql']['connection'],
					'DELETE FROM sms_out WHERE token = ?',
					array(
						array( 's' => $status['token'] )
					)
				);

				// log
				logWrite( 'SMS #' . $sms['id'] . ' rimosso dalla sms_out', 'sms' );

			}

		} else {

			// log
			logWrite( 'impossibile inviare l\'SMS #' . $sms['id'] . ' (errore)', 'sms', LOG_ERR );

			// incremento il numero di tentativi per l'SMS
			$tnInvio = $sms['tentativi'] + 1;

			// controllo il limite di tentativi
			if( ! empty( $cf['sms']['tentativi_massimi'] ) && $tnInvio >= $cf['sms']['tentativi_massimi'] ) {

				// NOTA la riga resta in coda con il token dedicato TROPPI_TENTATIVI, che la toglie dal giro normale, da hard e
				// full e dallo sblocco delle righe abbandonate; la riparte solo l'invio forzato di quella riga ( id )
				mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE sms_out SET tentativi = ?, token = ?, timestamp_elaborazione = NULL WHERE token = ?',
					array(
						array( 's' => $tnInvio ),
						array( 's' => 'TROPPI_TENTATIVI' ),
						array( 's' => $status['token'] )
					)
				);

				// log
				logWrite( 'SMS #' . $sms['id'] . ' non inviato dopo ' . $tnInvio . ' tentativi, resta nella sms_out fermo con il token TROPPI_TENTATIVI', 'sms', LOG_ERR );

				// status
				$status['err'][] = 'SMS non inviato dopo ' . $tnInvio . ' tentativi, non verrà più ritentato';

			} else {

				// se l'invio dà errore, procrastino
				$tsInvio = strtotime( '+' . $tnInvio . ' hour' );

				// aggiorno la timestamp di invio
				mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE sms_out SET timestamp_invio = ?, tentativi = ?, token = NULL, timestamp_elaborazione = NULL WHERE token = ?',
					array(
						array( 's' => $tsInvio ),
						array( 's' => $tnInvio ),
						array( 's' => $status['token'] )
					)
				);

			}

		}

	} else {

        // chiudo il ciclo
        $iter = ( ! empty( $task['iterazioni'] ) ) ? $task['iterazioni'] : 0;

		// status
		// NOTA con full=1 il task non cerca SMS da inviare, e ha già detto cosa ha fatto
		if( ! isset( $_REQUEST['full'] ) ) {
			$status['info'][] = 'nessun SMS da evadere';
		}

	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
