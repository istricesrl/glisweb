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
	$status['token'] = getToken( __FILE__ );

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
            'UPDATE mail_out SET token = ? WHERE token IS NULL '.
            'ORDER BY ordine ASC, timestamp_invio ASC LIMIT 1',
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
            'UPDATE mail_out SET token = ? WHERE ( timestamp_invio <= unix_timestamp() OR timestamp_invio IS NULL ) '.
            'AND token IS NULL '.
            'ORDER BY ordine ASC, timestamp_invio ASC LIMIT 1',
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

		// NOTA questa cosa è super grezza, non consente di salvare il selettore DKIM che è inchiodato a glisweb
		// la firma DKIM segue il dominio e in ogni dominio può essercene più d'una, ognuna identificata da un selettore diverso

		// ricavo il dominio di invio
		// NOTA fin qui va bene
		$mittente = unserialize( $mail['mittente'] );
		$dominio = explode( '@', array_shift( $mittente ) );
		$dominio = $dominio[1];

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
		logWrite( 'DKIM: ' . print_r( $dkim, true ), 'dkim', LOG_DEBUG );

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
			$smtp['port'],
			$dkim['domain'],
			$dkim['pasw']
		);

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
        $iter = $task['iterazioni'];

		// status
		$status['info'][] = 'nessuna mail da evadere';

	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
