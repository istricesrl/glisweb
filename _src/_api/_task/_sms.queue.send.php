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

    // log
	logWrite( 'richiesta di elaborazione della coda degli SMS in uscita', 'sms', LOG_DEBUG );

    // chiave di lock
	$status['token'] = getToken( __FILE__ );

	// modalità di evasione (specifica sms, evasione forzata, evasione naturale)
	if( isset( $_REQUEST['id'] ) ) {

		// token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE sms_out SET token = ? WHERE id = ? AND token IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );

	} elseif( isset( $_REQUEST['hard'] ) ) {

		// token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE sms_out SET token = ? WHERE token IS NULL '.
            'ORDER BY ordine ASC, timestamp_invio ASC LIMIT 1',
            array(
                array( 's' => $status['token'] )
            )
        );

	} else {

		// token della riga
        $status['id'] = mysqlQuery(
			$cf['mysql']['connection'],
			'UPDATE sms_out SET token = ? '.
			'WHERE ( timestamp_invio <= unix_timestamp() OR timestamp_invio IS NULL ) '.
			'AND token IS NULL '.
			'ORDER BY ordine ASC, timestamp_invio ASC LIMIT 1',
            array(
                array( 's' => $status['token'] )
            )
		);

	}

	// prelevo una sms dalla coda
	$sms = mysqlSelectRow(
		$cf['mysql']['connection'],
		'SELECT * FROM sms_out WHERE token = ?',
		array(
			array( 's' => $status['token'] )
		)
	);

    // se c'è almeno un SMS da inviare
	if( ! empty( $sms ) ) {

		// prelevo i dati del server
		$srv = (
			( ! empty( $sms['server'] ) )
			? $cf['sms']['servers'][ $sms['server'] ]
			: $cf['sms']['server']
		);

		// invio l'SMS
		switch( $srv['type'] ) {
			case 'skebby':
				$r = skebbySend(
					$sms['corpo'],
					array_values( unserialize( $sms['destinatari'] ) ),
					$srv['username'],
					$srv['password'],
					current( array_keys( unserialize( $sms['mittente'] ) ) )
				);
			break;
			case 'ehiweb':
				$r = ehiwebSend(
					$sms['corpo'],
					array_values( unserialize( $sms['destinatari'] ) ),
					$srv['username'],
					$srv['password'],
					current( array_keys( unserialize( $sms['mittente'] ) ) ),
					$srv['id_api']
				);
			break;
			default:
				logWrite( 'metodo di invio SMS non supportato: ' . $srv['type'], 'sms', LOG_ERR );
				$r = false;
			break;
		}

		// controllo l'esito dell'invio
		if( $r !== false ) {

			// log
			logWrite( 'invio SMS #' . $sms['id'] . ' completato: ' . $r, 'sms', LOG_NOTICE );

			// sposto la sms nella coda delle inviate
			$s1 = mysqlQuery(
				$cf['mysql']['connection'],
				'REPLACE INTO sms_sent SELECT * FROM sms_out WHERE token = ?',
				array(
					array( 's' => $status['token'] )
				)
			);

			// log
			logWrite( 'spostamento SMS #' . $sms['id'] . ' dalla sms_out alla sms_sent completato', 'sms', LOG_NOTICE );

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
			logWrite( 'timestamp di invio SMS #' . $sms['id'] . ' aggiornato', 'sms', LOG_NOTICE );

			// elimino la sms inviata dalla coda delle sms in uscita
			$s3 = mysqlQuery(
				$cf['mysql']['connection'],
				'DELETE FROM sms_out WHERE token = ?',
				array(
					array( 's' => $status['token'] )
				)
			);

			// log
			logWrite( 'SMS #' . $sms['id'] . ' rimosso dalla sms_out', 'sms', LOG_NOTICE );

		} else {

			// log
			logWrite( 'impossibile inviare SMS #' . $sms['id'] . ' (errore phpsmser)', 'sms', LOG_ERR );

			// incremento il numero di tentativi per l'SMS
			$tnInvio = $sms['tentativi'] + 1;

			// se l'invio dà errore, procrastino
			$tsInvio = strtotime( '+' . $tnInvio . ' hour' );

			// aggiorno la timestamp di invio
			mysqlQuery(
				$cf['mysql']['connection'],
				'UPDATE sms_out SET timestamp_invio = ?, tentativi = ? token = NULL WHERE token = ?',
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

	    // log
		logWrite( 'nessun SMS in coda da processare', 'sms' );

	    // status
		$status['info'][] = 'nessun SMS in coda da processare';

	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
