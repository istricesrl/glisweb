<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // status
	$status['info'][] = 'inizio evasione coda mail';

    // log
	logWrite( 'richiesta di elaborazione della coda delle mail in uscita', 'mail' );

    // chiave di lock
	$status['token'] = getToken();

    // inizializzo la variabile per l'invio
	// $mail = NULL;

	// modalità di evasione (specifica mail, evasione forzata, evasione naturale)
	if( isset( $_REQUEST['id'] ) ) {

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

		// token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mail_out SET token = ? WHERE token IS NULL '.
            'ORDER BY timestamp_invio ASC LIMIT 1',
            array(
                array( 's' => $status['token'] )
            )
        );

	} else {

		// token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mail_out SET token = ? WHERE timestamp_invio <= unix_timestamp() OR timestamp_invio IS NULL '.
            'AND token IS NULL '.
            'ORDER BY timestamp_invio ASC LIMIT 1',
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
		$smtp = (
			( ! empty( $mail['server'] ) )
			? $cf['smtp']['servers'][ $mail['server'] ]
			: $cf['smtp']['server']
		);

		// debug
		// var_dump( $smtp );

		// invio la mail
		$r = sendMail(
			$smtp['address'],
			unserialize( $mail['mittente'] ),
			unserialize( $mail['destinatari'] ),
			$mail['oggetto'],
			$mail['corpo'],
			unserialize( $mail['destinatari_cc'] ),
			unserialize( $mail['destinatari_bcc'] ),
			unserialize( $mail['allegati'] ),
			unserialize( $mail['headers'] ),
			$smtp['username'],
			$smtp['password'],
			$smtp['port']
		);

		// controllo l'esito dell'invio
		if( $r !== false ) {

			// log
			logWrite( 'invio della mail #' . $mail['id'] . ' completato: ' . $r, 'mail', LOG_NOTICE );

			// sposto la mail nella coda delle inviate
			$s1 = mysqlQuery(
				$cf['mysql']['connection'],
				'REPLACE INTO mail_sent SELECT * FROM mail_out WHERE token = ?',
				array(
					array( 's' => $status['token'] )
				)
			);

			// log
			logWrite( 'spostamento della mail #' . $mail['id'] . ' dalla mail_out alla mail_sent completato', 'mail', LOG_NOTICE );

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
			logWrite( 'timestamp di invio della mail #' . $mail['id'] . ' aggiornato', 'mail', LOG_NOTICE );

			// elimino la mail inviata dalla coda delle mail in uscita
			$s3 = mysqlQuery(
				$cf['mysql']['connection'],
				'DELETE FROM mail_out WHERE token = ?',
				array(
					array( 's' => $status['token'] )
				)
			);

			// log
			logWrite( 'mail #' . $mail['id'] . ' rimossa dalla mail_out', 'mail', LOG_NOTICE );

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
				'UPDATE mail_out SET timestamp_invio = ?, tentativi = ? token = NULL WHERE token = ?',
				array(
					array( 's' => $tsInvio ),
					array( 's' => $tnInvio ),
					array( 's' => $status['token'] )
				)
			);

		}

	} else {

		// status
		$status['info'][] = 'nessuna mail da evadere';

	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

?>
