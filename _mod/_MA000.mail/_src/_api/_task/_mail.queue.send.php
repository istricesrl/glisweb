<?php

    /**
     * evasione della coda delle mail in uscita
     *
     * Questo task invia una mail della coda `mail_out` a ogni chiamata: marca una riga con il proprio token, la legge, la
     * passa a sendMail() ( `_src/_lib/_mail.tools.php` ) e, se l'invio riesce, la sposta in `mail_sent`; se l'invio
     * fallisce la riga resta in coda, `tentativi` sale di uno e l'invio viene rimandato di tante ore quanti sono i
     * tentativi fatti, fino al limite descritto più sotto. Richiede il privilegio `GESTIONE_COMUNICAZIONI` ed è pensato
     * per il cron ogni minuto con più iterazioni.
     *
     * modalità di evasione
     * ====================
     * La modalità si sceglie con i parametri della richiesta:
     *
     * parametro        | comportamento
     * -----------------|------------------------------------------------------------------------------------------
     * id=<id>          | invia la mail indicata anche se non è ancora il suo momento, purché nessun altro processo l'abbia già marcata; una mail ferma per troppi tentativi riparte con i tentativi azzerati
     * hard=1           | invia la prima mail della coda per `ordine` e `timestamp_invio`, ignorando la data prevista
     * full=1           | rimette in circolo tutta la coda: azzera `timestamp_invio` su tutte le righe, tranne quelle ferme per troppi tentativi, e non invia nulla, la coda la riprende il cron dal giro successivo
     * nessuno          | invia, fra le mail la cui data prevista è passata o assente, la prima per `ordine` ( NULL per primo, sono le transazionali ) e `timestamp_invio`
     *
     * Con `full=1` il task risponde con quante mail avevano una data prevista, ora azzerata ( `rimesse` ), quante ne ha
     * sbloccate ( `sbloccate`, vedi sotto ) e quante restano ferme per troppi tentativi ( `ferme` ). Fino al 2026-09-30
     * rispondeva "nessuna mail da evadere", che sembrava un errore.
     *
     * righe marcate e mai rilasciate
     * ==============================
     * Il task marca la riga con il proprio token e scrive in `timestamp_elaborazione` l'ora della marcatura, nello stesso
     * UPDATE; alla fine del giro il token si toglie. Se il processo muore a metà, la riga resterebbe marcata e nessuna
     * modalità la prenderebbe più: per questo all'inizio di ogni giro, in tutte le modalità, il task toglie il token
     * alle righe marcate da più di `$cf['mail']['minuti_sblocco']` minuti ( default 60, in `_src/_config/_350.mail.php` ),
     * che tornano in coda come le altre. È lo stesso recupero che `_src/_api/_cron.php` fa su task, job e pianificazioni.
     * Una mail sbloccata così può partire due volte, se il processo era morto dopo averla consegnata al server SMTP e
     * prima di spostarla fra le inviate.
     *
     * server SMTP
     * ===========
     * Se la riga ha la colonna `server` valorizzata si usa `$cf['smtp']['servers'][ <server> ]`, altrimenti il server del
     * profilo corrente, `$cf['smtp']['server']`. Un server nominato nella riga ma assente dalla configurazione, o un
     * profilo senza server, sono un errore di invio come gli altri: la mail resta in coda, il tentativo si conta e
     * l'errore va nel log `mail`, come fa il task gemello degli SMS ( `_src/_api/_task/_sms.queue.send.php` ).
     *
     * lo spostamento fra le inviate
     * =============================
     * La copia in `mail_sent` è un `REPLACE INTO mail_sent SELECT * FROM mail_out`, quindi le due tabelle devono avere le
     * stesse colonne nello stesso ordine. Se la copia fallisce la mail è già partita: la riga NON viene cancellata da
     * `mail_out` e NON viene rimessa in coda, ma resta marcata con il token dedicato `COPIA_FALLITA`, che la esclude da
     * tutte le modalità di evasione ( anche da `id` ) e dallo sblocco delle righe abbandonate, e l'errore va nel log `mail`
     * a livello LOG_CRIT. Va sistemata a mano, allineando le tabelle e spostando la riga, o cancellandola dalla scheda
     * della mail in uscita. Fino al 2026-09-29 il task cancellava la riga da `mail_out` senza guardare l'esito della
     * copia, e una copia fallita faceva sparire la mail.
     *
     * Dopo la copia i file collegati alla mail ( `file.id_mail_out` ) passano alla mail inviata ( `file.id_mail_sent` ),
     * prima di cancellare la riga da `mail_out`, il cui vincolo ON DELETE SET NULL li staccherebbe dalla mail. Fino al
     * 2026-09-30 non si faceva, e la linguetta file della mail inviata era sempre vuota.
     *
     * Il task è la copia nel modulo `MA000.mail` di quello del core ( `_src/_api/_task/_mail.queue.send.php` ), e la chiama
     * la scheda strumenti della mail in uscita ( `mail.out.form.tools` ): le due copie vanno tenute uguali, cambia solo
     * l'inclusione del framework. Fino al 2026-09-29 questa copia non aveva la correzione del dominio DKIM per i mittenti
     * non validi che il core aveva già.
     *
     * limite di tentativi
     * ===================
     * Quando i tentativi falliti arrivano a `$cf['mail']['tentativi_massimi']` ( default 10, in `_src/_config/_350.mail.php`;
     * con 0 il limite non c'è ) la mail non si riprova più: la riga resta in `mail_out` con i tentativi fatti e il token
     * dedicato `TROPPI_TENTATIVI`, e l'errore va nel log `mail` a livello LOG_ERR. Come `COPIA_FALLITA` il token la toglie
     * dal giro normale, da `hard=1` e dallo sblocco delle righe abbandonate, e `full=1` non la rimette in circolo: una
     * mail che ha fallito tante volte di fila ha di solito un problema che il tempo non risolve ( un indirizzo rifiutato,
     * un server sbagliato ), e ritentarla a ogni "elabora coda" riempirebbe il log senza farla partire. La fa ripartire
     * `id=<id>`, cioè l'invio forzato dalla scheda della mail in uscita, che toglie il token e azzera i tentativi prima di
     * marcarla: se fallisce ancora ricomincia il conteggio. Il limite c'era già nel primo disegno del task, del 2020
     * ( "se i tentativi sono più di 5, notificare il mittente e spostarla in mail_unsent" ), ma non era mai stato scritto:
     * fino al 2026-09-30 una mail che falliva sempre veniva riprovata all'infinito.
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
	$status['info'][] = 'inizio evasione coda mail';

    // log
	logWrite( 'richiesta di elaborazione della coda delle mail in uscita', 'mail' );

    // chiave di lock
    if( ! isset( $status['token'] ) ) {
        $status['token'] = getToken( __FILE__ );
    }

    // inizializzo la variabile per l'invio
	// $mail = NULL;

    // sblocco delle mail marcate e mai rilasciate
    // NOTA restano fuori le righe bloccate apposta dopo una copia fallita, che vanno sistemate a mano, e quelle ferme
    // per troppi tentativi, che riparte solo l'invio forzato di quella riga
    $status['sbloccate'] = mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE mail_out SET token = NULL, timestamp_elaborazione = NULL WHERE token IS NOT NULL AND token NOT IN ( ?, ? ) AND timestamp_elaborazione < ?',
        array(
            array( 's' => 'COPIA_FALLITA' ),
            array( 's' => 'TROPPI_TENTATIVI' ),
            array( 's' => strtotime( '-' . $cf['mail']['minuti_sblocco'] . ' minutes' ) )
        )
    );

    // log
    if( ! empty( $status['sbloccate'] ) ) {
        logWrite( 'sbloccate ' . $status['sbloccate'] . ' mail marcate da più di ' . $cf['mail']['minuti_sblocco'] . ' minuti', 'mail', LOG_WARNING );
    }

	// modalità di evasione (specifica mail, evasione forzata, evasione totale, evasione naturale)
	if( isset( $_REQUEST['id'] ) ) {

		// status
		$status['info'][] = 'evasione specifico messaggio in coda';

        // se la riga è ferma per troppi tentativi la rimetto in coda con i tentativi azzerati
        // NOTA è l'unico modo di farla ripartire: il giro normale, hard e full non la prendono
        $status['riprese'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mail_out SET token = NULL, tentativi = 0 WHERE id = ? AND token = ?',
            array(
                array( 's' => $_REQUEST['id'] ),
                array( 's' => 'TROPPI_TENTATIVI' )
            )
        );

        // log
        if( ! empty( $status['riprese'] ) ) {
            logWrite( 'mail #' . $_REQUEST['id'] . ' ferma per troppi tentativi rimessa in coda a mano, con i tentativi azzerati', 'mail' );
        }

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mail_out SET token = ?, timestamp_elaborazione = ? WHERE id = ? AND token IS NULL',
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
            'UPDATE mail_out SET token = ?, timestamp_elaborazione = ? WHERE token IS NULL 
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
            'UPDATE mail_out SET timestamp_invio = NULL WHERE ( token IS NULL OR token <> ? )',
            array(
                array( 's' => 'TROPPI_TENTATIVI' )
            )
        );

        // conto le righe ferme per troppi tentativi
        $status['ferme'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT count( id ) FROM mail_out WHERE token = ?',
            array(
                array( 's' => 'TROPPI_TENTATIVI' )
            )
        );

		// status
		$status['info'][] = 'mail con la data prevista azzerata: ' . intval( $status['rimesse'] ) . ', mail sbloccate: ' . intval( $status['sbloccate'] ) . '; tutta la coda è inviabile e la riprende il cron dal prossimo giro, tranne le mail ferme per troppi tentativi: ' . intval( $status['ferme'] ) . ', che riparte solo l\'invio forzato dalla scheda';

		// log
		logWrite( 'coda delle mail rimessa in circolo: ' . intval( $status['rimesse'] ) . ' date previste azzerate', 'mail' );

	} else {

		// status
		$status['info'][] = 'strategia standard di evasione della coda';

		// token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mail_out SET token = ?, timestamp_elaborazione = ? WHERE ( timestamp_invio <= unix_timestamp() OR timestamp_invio IS NULL ) 
                AND token IS NULL 
                ORDER BY ordine ASC, timestamp_invio ASC LIMIT 1',
            array(
                array( 's' => $status['token'] ),
                array( 's' => time() )
            )
        );

	}

	// prelevo una mail dalla coda
	$mail = mysqlSelectRow(
		$cf['mysql']['connection'],
		'SELECT * FROM mail_out WHERE token = ?',
		array(
			array( 's' => $status['token'] )
		)
	);

	// se c'è almeno una mail da inviare
	if( ! empty( $mail ) ) {

		// status
		$status['info'][] = 'trovata una mail da evadere';

		// prelevo i dati del server
		// TODO questo è da fare meglio, i dati possono essere anche in $mail e in $cf['smtp']['server'] non è detto che ci siano tutti OCCHIO che address sulle tabelle è host e username è user
		// NOTA un server nominato nella riga ma assente da $cf['smtp']['servers'] non ricade sul server di default: resta
		// NULL e più sotto la mail non parte, come con un profilo senza server ( 2026-09-29, come il task degli SMS )
		$smtp = (
			( ! empty( $mail['server'] ) )
			? ( $cf['smtp']['servers'][ $mail['server'] ] ?? NULL )
			: ( $cf['smtp']['server'] ?? NULL )
		);

		// NOTA questa cosa è super grezza, non consente di salvare il selettore DKIM che è inchiodato a glisweb
		// la firma DKIM segue il dominio e in ogni dominio può essercene più d'una, ognuna identificata da un selettore diverso

		// ricavo il dominio di invio
		// NOTA il mittente arriva da unserialize() di una colonna della coda: quando il valore
		// serializzato non e' un array (in coda si trovano righe con 'N;', cioe' NULL) array_shift()
		// solleva un warning e l'explode successivo non ha un indice 1. Senza dominio la firma DKIM
		// non si applica, che e' gia' il comportamento previsto dal ramo else qui sotto.
		$mittente = unserialize( $mail['mittente'] );
		$dominio = ( is_array( $mittente ) && ! empty( $mittente ) ) ? explode( '@', array_shift( $mittente ) ) : array();
		$dominio = ( isset( $dominio[1] ) ) ? $dominio[1] : '';

		// debug
		// print_r( unserialize( $mail['mittente'] ) );
		// var_dump( $dominio );

		// se è configurato il DKIM per il dominio
		// NOTA qui il selettore dovrebbe essere indicato da...?
		if( isset( $cf['smtp']['dkim'][ $dominio ]['glisweb'] ) ) {
			$dkim = array(
				'domain' => $dominio,
				'pasw' => $cf['smtp']['dkim'][ $dominio ]['glisweb']['password']
			);
		} else {
			$dkim = array(
				'domain' => '',
				'pasw' => ''
			);
		}

		// debug
		// var_dump( $smtp );
		// var_dump( $dkim );

		// log
		// NOTA la passphrase non si scrive: fino al 24/09/2026 print_r( $dkim ) la metteva in chiaro nel log dkim
		logWrite( 'DKIM: ' . $dkim['domain'] . ' : passphrase ' . ( empty( $dkim['pasw'] ) ? 'non impostata' : 'impostata' ), 'dkim', LOG_DEBUG );

		// invio la mail
		if( ! empty( $smtp['address'] ) ) {

			$r = sendMail(
				$smtp['address'],
				unserialize( $mail['mittente'] ?? '' ),
				unserialize( $mail['destinatari'] ?? '' ),
				$mail['oggetto'],
				$mail['corpo'],
				unserialize( $mail['destinatari_cc'] ?? '' ),
				unserialize( $mail['destinatari_bcc'] ?? '' ),
				unserialize( $mail['allegati'] ?? '' ),
				unserialize( $mail['headers'] ?? '' ),
				$smtp['username'] ?? NULL,
				$smtp['password'] ?? NULL,
				$smtp['port'] ?? 25,
				$dkim['domain'],
				$dkim['pasw']
			);

		} else {

			// log
			logWrite( 'server SMTP ' . ( ( ! empty( $mail['server'] ) ) ? $mail['server'] : 'di default' ) . ' per la mail #' . $mail['id'] . ' non configurato', 'mail', LOG_ERR );

			// status
			$status['err'][] = 'server SMTP non configurato';

			// esito
			$r = false;

		}

		// controllo l'esito dell'invio
		if( $r !== false ) {

			// RELAZIONI CON IL MODULO MAILING
			if( in_array( "7000.mailing", $cf['mods']['active']['array'] ) || in_array( "ML000.mailing", $cf['mods']['active']['array'] ) ) {

				// aggiorno la riga
				$ml = mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE mailing_mail '.
					'SET mailing_mail.timestamp_invio = ? '.
					'WHERE mailing_mail.id_mail_out = ?',
					array(
						array( 's' => time() ),
						array( 's' => $mail['id'] )
					)
				);

				// log
				logWrite( 'registrato invio della mail #' . $mail['id'] . ' per associazione mailing mail #' . $ml, 'mailing' );

			}

			// log
			logWrite( 'invio della mail #' . $mail['id'] . ' completato: ' . $r, 'mail' );

			// sposto la mail nella coda delle inviate
			$s1 = mysqlQuery(
				$cf['mysql']['connection'],
				'REPLACE INTO mail_sent SELECT * FROM mail_out WHERE token = ?',
				array(
					array( 's' => $status['token'] )
				)
			);

			// controllo l'esito dello spostamento
			// NOTA mysqlQuery() restituisce false se la query solleva un'eccezione, ma -1 ( le righe toccate da uno statement
			// fallito ) se l'esecuzione fallisce senza eccezione, come succede prima di PHP 8.1
			if( empty( $s1 ) || $s1 < 0 ) {

				// NOTA la mail è già partita: la riga resta nella mail_out con il token dedicato COPIA_FALLITA, che la toglie da
				// tutte le modalità di evasione e dallo sblocco delle righe abbandonate, così non viene né persa né inviata una
				// seconda volta
				mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE mail_out SET token = ? WHERE token = ?',
					array(
						array( 's' => 'COPIA_FALLITA' ),
						array( 's' => $status['token'] )
					)
				);

				// log
				logWrite( 'mail #' . $mail['id'] . ' inviata ma non copiata nella mail_sent, resta nella mail_out bloccata dal token COPIA_FALLITA', 'mail', LOG_CRIT );

				// status
				$status['err'][] = 'mail inviata ma non spostata fra le inviate';

			} else {

				// log
				logWrite( 'spostamento della mail #' . $mail['id'] . ' dalla mail_out alla mail_sent completato', 'mail' );

				// aggiorno la timestamp di invio
				$s2 = mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE mail_sent SET timestamp_invio = ?, token = NULL, timestamp_elaborazione = NULL WHERE token = ?',
					array(
						array( 's' => time() ),
						array( 's' => $status['token'] )
					)
				);

				// log
				logWrite( 'timestamp di invio della mail #' . $mail['id'] . ' aggiornato', 'mail' );

				// sposto gli allegati sulla mail inviata
				// NOTA va fatto prima del DELETE, che con il vincolo ON DELETE SET NULL azzera file.id_mail_out; l'indice unico
				// ( id_mail_sent, id_ruolo, path ) non può collidere: nessun file punta già a questa mail inviata, perché la
				// riga di mail_sent l'ha appena scritta il REPLACE, e se ne esisteva una con lo stesso id il REPLACE l'ha
				// cancellata staccandone i file con lo stesso vincolo
				$s4 = mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE file SET id_mail_sent = id_mail_out WHERE id_mail_out = ?',
					array(
						array( 's' => $mail['id'] )
					)
				);

				// log
				logWrite( 'file collegati alla mail #' . $mail['id'] . ' spostati sulla mail inviata: ' . intval( $s4 ), 'mail' );

				// elimino la mail inviata dalla coda delle mail in uscita
				$s3 = mysqlQuery(
					$cf['mysql']['connection'],
					'DELETE FROM mail_out WHERE token = ?',
					array(
						array( 's' => $status['token'] )
					)
				);

				// log
				logWrite( 'mail #' . $mail['id'] . ' rimossa dalla mail_out', 'mail' );

			}

		} else {

			// log
			logWrite( 'impossibile inviare la mail #' . $mail['id'] . ' (errore phpMailer)', 'mail', LOG_ERR );

			// incremento il numero di tentativi per la mail
			$tnInvio = $mail['tentativi'] + 1;

			// controllo il limite di tentativi
			if( ! empty( $cf['mail']['tentativi_massimi'] ) && $tnInvio >= $cf['mail']['tentativi_massimi'] ) {

				// NOTA la riga resta in coda con il token dedicato TROPPI_TENTATIVI, che la toglie dal giro normale, da hard e
				// full e dallo sblocco delle righe abbandonate; la riparte solo l'invio forzato di quella riga ( id )
				mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE mail_out SET tentativi = ?, token = ?, timestamp_elaborazione = NULL WHERE token = ?',
					array(
						array( 's' => $tnInvio ),
						array( 's' => 'TROPPI_TENTATIVI' ),
						array( 's' => $status['token'] )
					)
				);

				// log
				logWrite( 'mail #' . $mail['id'] . ' non inviata dopo ' . $tnInvio . ' tentativi, resta nella mail_out ferma con il token TROPPI_TENTATIVI', 'mail', LOG_ERR );

				// status
				$status['err'][] = 'mail non inviata dopo ' . $tnInvio . ' tentativi, non verrà più ritentata';

			} else {

				// se l'invio dà errore, procrastino
				$tsInvio = strtotime( '+' . $tnInvio . ' hour' );

				// aggiorno la timestamp di invio
				mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE mail_out SET timestamp_invio = ?, tentativi = ?, token = NULL, timestamp_elaborazione = NULL WHERE token = ?',
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
		// NOTA con full=1 il task non cerca mail da inviare, e ha già detto cosa ha fatto
		if( ! isset( $_REQUEST['full'] ) ) {
			$status['info'][] = 'nessuna mail da evadere';
		}

	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
