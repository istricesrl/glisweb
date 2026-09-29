<?php

    /**
     * evasione della coda delle mail in uscita
     *
     * Questo task invia una mail della coda `mail_out` a ogni chiamata: marca una riga con il proprio token, la legge, la
     * passa a sendMail() ( `_src/_lib/_mail.tools.php` ) e, se l'invio riesce, la sposta in `mail_sent`; se l'invio
     * fallisce la riga resta in coda, `tentativi` sale di uno e l'invio viene rimandato di tante ore quanti sono i
     * tentativi fatti. Richiede il privilegio `GESTIONE_COMUNICAZIONI` ed è pensato per il cron ogni minuto con più
     * iterazioni.
     *
     * modalità di evasione
     * ====================
     * La modalità si sceglie con i parametri della richiesta:
     *
     * parametro        | comportamento
     * -----------------|------------------------------------------------------------------------------------------
     * id=<id>          | invia la mail indicata anche se non è ancora il suo momento, purché nessun altro processo l'abbia già marcata
     * hard=1           | invia la prima mail della coda per `ordine` e `timestamp_invio`, ignorando la data prevista
     * full=1           | azzera `timestamp_invio` su tutta la coda, così che i giri successivi la evadano per intero; in questo giro non invia nulla
     * nessuno          | invia la prima mail la cui data prevista è passata o assente
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
     * `mail_out` e NON viene rimessa in coda, ma resta marcata con il token di questo giro, che la esclude da tutte le
     * modalità di evasione ( anche da `id` ), e l'errore va nel log `mail` a livello LOG_CRIT. Va sistemata a mano,
     * allineando le tabelle e spostando la riga, o cancellandola dalla scheda della mail in uscita. Fino al 2026-09-29 il
     * task cancellava la riga da `mail_out` senza guardare l'esito della copia, e una copia fallita faceva sparire la mail.
     *
     * Il task è la copia nel modulo `MA000.mail` di quello del core ( `_src/_api/_task/_mail.queue.send.php` ), e la chiama
     * la scheda strumenti della mail in uscita ( `mail.out.form.tools` ): le due copie vanno tenute uguali, cambia solo
     * l'inclusione del framework. Fino al 2026-09-29 questa copia non aveva la correzione del dominio DKIM per i mittenti
     * non validi che il core aveva già.
     *
     * NOTA il task non ha un numero massimo di tentativi: una mail che fallisce sempre viene riprovata all'infinito, a
     * intervalli che crescono di un'ora a ogni tentativo.
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

	// modalità di evasione (specifica mail, evasione forzata, evasione totale, evasione naturale)
	if( isset( $_REQUEST['id'] ) ) {

		// status
		$status['info'][] = 'evasione specifico messaggio in coda';

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mail_out SET token = ? WHERE id = ? AND token IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );

	} elseif( isset( $_REQUEST['hard'] ) ) {

		// status
		$status['info'][] = 'evasione forzata della coda';

		// token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mail_out SET token = ? WHERE token IS NULL 
                ORDER BY ordine ASC, timestamp_invio ASC LIMIT 1',
            array(
                array( 's' => $status['token'] )
            )
        );

	} elseif( isset( $_REQUEST['full'] ) ) {

		// status
		$status['info'][] = 'forzatura elaborazione totale della coda';

		// token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mail_out SET timestamp_invio = NULL'
        );

	} else {

		// status
		$status['info'][] = 'strategia standard di evasione della coda';

		// token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mail_out SET token = ? WHERE ( timestamp_invio <= unix_timestamp() OR timestamp_invio IS NULL ) 
                AND token IS NULL 
                ORDER BY ordine ASC, timestamp_invio ASC LIMIT 1',
            array(
                array( 's' => $status['token'] )
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
			if( in_array( "7000.mailing", $cf['mods']['active']['array'] ) ) {

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

				// NOTA la mail è già partita: la riga resta nella mail_out con il token di questo giro, che la toglie da tutte
				// le modalità di evasione, così non viene né persa né inviata una seconda volta
				logWrite( 'mail #' . $mail['id'] . ' inviata ma non copiata nella mail_sent, resta nella mail_out bloccata dal token ' . $status['token'], 'mail', LOG_CRIT );

				// status
				$status['err'][] = 'mail inviata ma non spostata fra le inviate';

			} else {

				// log
				logWrite( 'spostamento della mail #' . $mail['id'] . ' dalla mail_out alla mail_sent completato', 'mail' );

				// aggiorno la timestamp di invio
				$s2 = mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE mail_sent SET timestamp_invio = ?, token = NULL WHERE token = ?',
					array(
						array( 's' => time() ),
						array( 's' => $status['token'] )
					)
				);

				// log
				logWrite( 'timestamp di invio della mail #' . $mail['id'] . ' aggiornato', 'mail' );

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

			// se l'invio dà errore, procrastino
			$tsInvio = strtotime( '+' . $tnInvio . ' hour' );

			// aggiorno la timestamp di invio
			mysqlQuery(
				$cf['mysql']['connection'],
				'UPDATE mail_out SET timestamp_invio = ?, tentativi = ?, token = NULL WHERE token = ?',
				array(
					array( 's' => $tsInvio ),
					array( 's' => $tnInvio ),
					array( 's' => $status['token'] )
				)
			);

		}

	} else {

        // chiudo il ciclo
        $iter = ( ! empty( $task['iterazioni'] ) ) ? $task['iterazioni'] : 0;

		// status
		$status['info'][] = 'nessuna mail da evadere';

	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
