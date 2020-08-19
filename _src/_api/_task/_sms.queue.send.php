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
	require_once '../../_config.php';

    // inizializzo l'array del risultato
	$status = array();

    // log
	logWrite( 'richiesta di elaborazione della coda degli SMS in uscita', 'sms', LOG_DEBUG );

    // lock delle tabelle della coda
	mysqlQuery( $cf['mysql']['connection'], 'LOCK TABLES sms_out WRITE, sms_sent WRITE' );

    // prelevo un SMS dalla coda
	$sms = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM sms_out WHERE timestamp_invio <= unix_timestamp() OR timestamp_invio IS NULL ORDER BY timestamp_invio LIMIT 1' );

    // se c'è almeno un SMS da inviare
	if( ! empty( $sms ) ) {

	    // inizio la transazione
		if( mysqlQuery( $cf['mysql']['connection'], 'START TRANSACTION' ) ) {

		    // sposto l'SMS da una coda all'altra
			if( mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO sms_sent SELECT * FROM sms_out WHERE id = ?', array( array( 's' => $sms['id'] ) ) ) == false ) {

			    // aggiorno la timestamp di invio
				if( mysqlQuery( $cf['mysql']['connection'], 'UPDATE sms_sent SET timestamp_invio = ? WHERE id = ?', array( array( 's' => time() ), array( 's' => $sms['id'] ) ) ) ) {

				    // elimino l'SMS inviato dalla coda degli SMS in uscita
					if( mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM sms_out WHERE id = ?', array( array( 's' => $sms['id'] ) ) ) ) {

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

						    // commit
							mysqlQuery( $cf['mysql']['connection'], 'COMMIT' );

						    // log
							logWrite( 'invio SMS dalla coda completato: ' . var_export( $r, true ), 'sms', LOG_ERR );

						} else {

						    // rollback
							mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );

						    // se l'invio dà errore, procrastino
							mysqlQuery( $cf['mysql']['connection'], 'UPDATE sms_out SET timestamp_invio = ? WHERE id = ?', array( array( 's' => strtotime( '+1 hour') ), array( 's' => $sms['id'] ) ) );

						    // log
							logWrite( 'impossibile inviare l\'SMS: ' . var_export( $r, true ), 'sms', LOG_ERR );

						}

					} else {

					    // rollback
						mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );

					    // log
						logWrite( 'impossibile eliminare l\'SMS inviato da sms_out', 'sms', LOG_ERR );

					}

				} else {

				    // rollback
					mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );

				    // log
					logWrite( 'impossibile aggiornare la timestamp_invio in sms_sent', 'sms', LOG_ERR );

				}

			} else {

			    // rollback
				mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );

			    // log
				logWrite( 'impossibile spostare l\'SMS #' . $sms['id'] . ' da sms_out a sms_sent', 'sms', LOG_ERR );

			}

		} else {

		    // log
			logWrite( 'impossibile avviare la transazione per evadere la coda', 'sms', LOG_ERR );

		}

	} else {

	    // log
		logWrite( 'nessun SMS in coda da processare', 'sms', LOG_INFO );

	    // status
		$status['info'][] = 'nessun SMS in coda da processare';

	}

    // unlock delle tabelle
	mysqlQuery( $cf['mysql']['connection'], 'UNLOCK TABLES' );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

?>
