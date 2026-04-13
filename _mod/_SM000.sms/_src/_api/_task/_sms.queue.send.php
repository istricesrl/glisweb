<?php

    /**
     *
     *
     *
     *
     * TODO commentare
     *
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

    // inizializzo la variabile per l'invio
	// $sms = NULL;

	// modalità di evasione (specifica sms, evasione forzata, evasione totale, evasione naturale)
	if( isset( $_REQUEST['id'] ) ) {

		// status
		$status['info'][] = 'evasione specifico messaggio in coda';

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE sms_out SET token = ? WHERE id = ?',
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
            'UPDATE sms_out SET token = ? WHERE token IS NULL 
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
            'UPDATE sms_out SET timestamp_invio = NULL'
        );

	} else {

		// status
		$status['info'][] = 'strategia standard di evasione della coda';

		// token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE sms_out SET token = ? WHERE ( timestamp_invio <= unix_timestamp() OR timestamp_invio IS NULL ) 
                AND token IS NULL 
                ORDER BY ordine ASC, timestamp_invio ASC LIMIT 1',
            array(
                array( 's' => $status['token'] )
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
		// TODO questo è da fare meglio, i dati possono essere anche in $sms e in $cf['smtp']['server'] non è detto che ci siano tutti OCCHIO che address sulle tabelle è host e username è user
		$server = (
			( ! empty( $sms['server'] ) )
			? $cf['sms']['servers'][ $sms['server'] ]
			: $cf['sms']['server']
		);

        // debug
        // die( print_r( $server, true ) );

		// invio l'SMS
		switch( $server['type'] ) {

			case 'skebby':

				$r = skebbySend(
					$sms['corpo'],
					unserialize( $sms['destinatari'] ?? '' ),
					$server['username'],
					$server['password'],
					unserialize( $sms['mittente'] ?? '' ),
				);

			break;

		}

		// controllo l'esito dell'invio
		if( $r !== false ) {

			// log
			logWrite( 'invio SMS #' . $sms['id'] . ' completato: ' . $r, 'sms' );

			// sposto la sms nella coda delle inviate
			$s1 = mysqlQuery(
				$cf['mysql']['connection'],
				'REPLACE INTO sms_sent SELECT * FROM sms_out WHERE token = ?',
				array(
					array( 's' => $status['token'] )
				)
			);

			// log
			logWrite( 'spostamento SMS #' . $sms['id'] . ' dalla sms_out alla sms_sent completato', 'sms' );

			// aggiorno la timestamp di invio
			$s2 = mysqlQuery(
				$cf['mysql']['connection'],
				'UPDATE sms_sent SET timestamp_invio = ?, token = NULL WHERE token = ?',
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

		} else {

			// log
			logWrite( 'impossibile inviare l\'SMS #' . $sms['id'] . ' (errore)', 'sms', LOG_ERR );

			// incremento il numero di tentativi per l'SMS
			$tnInvio = $sms['tentativi'] + 1;

			// se l'invio dà errore, procrastino
			$tsInvio = strtotime( '+' . $tnInvio . ' hour' );

			// aggiorno la timestamp di invio
			mysqlQuery(
				$cf['mysql']['connection'],
				'UPDATE sms_out SET timestamp_invio = ?, tentativi = ?, token = NULL WHERE token = ?',
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
		$status['info'][] = 'nessun SMS da evadere';

	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
