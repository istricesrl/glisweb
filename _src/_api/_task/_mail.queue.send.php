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

    // inizializzo la variabile per l'invio
	$out = NULL;

    // log
	logWrite( 'richiesta di elaborazione della coda delle mail in uscita', 'mail' );

    // lock delle tabelle della coda
	$lock = mysqlQuery( $cf['mysql']['connection'], 'LOCK TABLES mail_out WRITE, mail_sent WRITE' );

    // se il lock è andato a buon fine
	if( $lock === true ) {

	    // timer
		timerCheck( $cf['speed'], ' -> richiesto lock per evasione coda mail' );

	    // forzo la timestamp di invio
		if( isset( $_REQUEST['hard'] ) ) {
		    logWrite( 'richiesta FORZATA di elaborazione della coda delle mail in uscita', 'mail' );
		    mysqlQuery(
			$cf['mysql']['connection'],
			'UPDATE mail_out SET timestamp_invio = NULL ORDER BY id DESC LIMIT 1'
		    );
		}

	    // prelevo una mail dalla coda
		$mail = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM mail_out WHERE timestamp_invio <= unix_timestamp() OR timestamp_invio IS NULL ORDER BY timestamp_invio LIMIT 1' );

	    // se c'è almeno una mail da inviare
		if( ! empty( $mail ) ) {

		    // inizio la transazione
			if( mysqlQuery( $cf['mysql']['connection'], 'START TRANSACTION' ) ) {

			    // disabilito l'autocommit
				if( mysqlQuery( $cf['mysql']['connection'], 'SET autocommit = 0' ) ) {

				    // sposto la mail da una coda all'altra
#					if( mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO mail_sent SELECT * FROM mail_out WHERE id = ?', array( array( 's' => $mail['id'] ) ) ) !== false ) {
					if( mysqlQuery( $cf['mysql']['connection'], 'REPLACE INTO mail_sent SELECT * FROM mail_out WHERE id = ?', array( array( 's' => $mail['id'] ) ) ) !== false ) {

					    // aggiorno la timestamp di invio
						if( mysqlQuery( $cf['mysql']['connection'], 'UPDATE mail_sent SET timestamp_invio = ? WHERE id = ?', array( array( 's' => time() ), array( 's' => $mail['id'] ) ) ) !== false ) {

						    // elimino la mail inviata dalla coda delle mail in uscita
							if( mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM mail_out WHERE id = ?', array( array( 's' => $mail['id'] ) ) ) !== false ) {

							    // TODO
							    // la logica di questo script va modificata come segue:
							    // - qui si fa solo il commit
							    // - l'invio con sendMail() si fa dopo (vedi altro TODO in basso)
							    // - se l'invio va a buon fine, tutto ok non serve di fare altro
							    // - se l'invio non va a buon fine:
							    // - - il numero di tentativi di invio della mail va incrementato di uno
							    // - - la timestamp di invio della mail va incrementata di (60 * tentativi) minuti
							    // - - se i tentativi sono più di 5, notificare il mittente e spostarla in mail_unsent

							    // NOTA parzialmente implementato, manca l'implementazione della procrastinazione progressiva ecc.

/*
							    // prelevo i dati del server
							    // TODO questo è da fare meglio, i dati possono essere anche in $mail e in $cf['smtp']['server'] non è detto che ci siano tutti OCCHIO che address sulle tabelle è host e username è user
								$smtp = (
								    ( ! empty( $mail['server'] ) )
								    ? $cf['smtp']['servers'][ $mail['server'] ]
								    : $cf['smtp']['server']
								);
*/

							    // commit
								mysqlQuery( $cf['mysql']['connection'], 'COMMIT' );

							    // inizializzo la variabile per l'invio
								$out = $mail;

							    // log
								logWrite( 'spostamento della mail #' . $mail['id'] . ' dalla mail_out alla mail_sent completato', 'mail', LOG_ERR );

/*
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

								    // commit
									mysqlQuery( $cf['mysql']['connection'], 'COMMIT' );

								    // log
									logWrite( 'invio della mail dalla coda completato: ' . $r, 'mail', LOG_ERR );

								} else {

								    // rollback
									mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );

								    // se l'invio dà errore, procrastino
									mysqlQuery( $cf['mysql']['connection'], 'UPDATE mail_out SET timestamp_invio = ? WHERE id = ?', array( array( 's' => strtotime( '+1 hour') ), array( 's' => $mail['id'] ) ) );

								    // log
									logWrite( 'impossibile inviare la mail', 'mail', LOG_ERR );

								}
*/
								} else {

								    // rollback
									mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );

								    // log
									logWrite( 'impossibile eliminare la mail #' . $mail['id'] . ' da mail_out', 'mail', LOG_ERR );

								}

							} else {

						    // rollback
							mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );

						    // log
							logWrite( 'impossibile aggiornare la timestamp_invio in mail_sent per la mail #' . $mail['id'], 'mail', LOG_ERR );

						}

					} else {

					    // rollback
						mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );

					    // log
						logWrite( 'impossibile spostare la mail #' . $mail['id'] . ' da mail_out a mail_sent', 'mail', LOG_ERR );

					}

				    // riabilito l'autocommit
					mysqlQuery( $cf['mysql']['connection'], 'SET autocommit = 1' );

				} else {

				    // log
					logWrite( 'impossibile disabilitare il commit automatico per inviare la mail #' . $mail['id'], 'mail', LOG_ERR );

				}

			} else {

			    // log
				logWrite( 'impossibile avviare la transazione per inviare la mail #' . $mail['id'], 'mail', LOG_ERR );

			}

		} else {

		    // log
			logWrite( 'nessuna mail in coda da processare', 'mail', LOG_INFO );

		    // status
			$status['info'][] = 'nessuna mail in coda da processare';

		}

	    // unlock delle tabelle
		mysqlQuery( $cf['mysql']['connection'], 'UNLOCK TABLES' );

	    // timer
		timerCheck( $cf['speed'], ' -> rilascio lock per evasione coda mail' );

	    // TODO
		// qui fare l'invio con mail_send()
		// NOTA la variabile $mail è ancora valorizzata
		// NOTA --> fatto, controllare che vada

	    // se c'è almeno una mail da inviare
		if( ! empty( $out ) ) {

		    // prelevo i dati del server
		    // TODO questo è da fare meglio, i dati possono essere anche in $out e in $cf['smtp']['server'] non è detto che ci siano tutti OCCHIO che address sulle tabelle è host e username è user
			$smtp = (
			    ( ! empty( $out['server'] ) )
			    ? $cf['smtp']['servers'][ $out['server'] ]
			    : $cf['smtp']['server']
			);

		    // debug
			// var_dump( $smtp );

		    // invio la mail
			$r = sendMail(
			    $smtp['address'],
			    unserialize( $out['mittente'] ),
			    unserialize( $out['destinatari'] ),
			    $out['oggetto'],
			    $out['corpo'],
			    unserialize( $out['destinatari_cc'] ),
			    unserialize( $out['destinatari_bcc'] ),
			    unserialize( $out['allegati'] ),
			    unserialize( $out['headers'] ),
			    $smtp['username'],
			    $smtp['password'],
			    $smtp['port']
			);

		    // controllo l'esito dell'invio
			if( $r !== false ) {

			    // log
				logWrite( 'invio della mail #' . $out['id'] . ' completato: ' . $r, 'mail', LOG_ERR );

			} else {

			    // log
				logWrite( 'impossibile inviare la mail #' . $out['id'] . ' (errore phpMailer)', 'mail', LOG_ERR );

			    // se l'invio dà errore, procrastino
				$tsInvio = strtotime( '+1 hour');

			    // lock delle tabelle della coda
				$lock = mysqlQuery( $cf['mysql']['connection'], 'LOCK TABLES mail_out WRITE, mail_sent WRITE' );

			    // se il lock è andato a buon fine
				if( $lock === true ) {

				    // inizio la transazione
					if( mysqlQuery( $cf['mysql']['connection'], 'START TRANSACTION' ) ) {

					    // disabilito l'autocommit
						if( mysqlQuery( $cf['mysql']['connection'], 'SET autocommit = 0' ) !== false ) {

						    // sposto la mail da una coda all'altra
							if( mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO mail_out SELECT * FROM mail_sent WHERE id = ?', array( array( 's' => $out['id'] ) ) ) !== false ) {

							    // aggiorno la timestamp di invio
								if( mysqlQuery( $cf['mysql']['connection'], 'UPDATE mail_out SET timestamp_invio = ? WHERE id = ?', array( array( 's' => $tsInvio ), array( 's' => $out['id'] ) ) ) !== false ) {

								    // elimino la mail inviata dalla coda delle mail in uscita
									if( mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM mail_sent WHERE id = ?', array( array( 's' => $out['id'] ) ) ) !== false ) {

									    // log
										logWrite( 'mail #' . $out['id'] . ' non inviata e riportata correttamente in mail_out, invio previsto a ' . date( 'Y-m-d H:i:s', $tsInvio ), 'mail', LOG_ERR );

									    // commit
										mysqlQuery( $cf['mysql']['connection'], 'COMMIT' );

									} else {

									    // log
										logWrite( 'impossibile cancellare la mail #' . $out['id'] . ' da mail_sent', 'mail', LOG_ERR );

									    // rollback
										mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );

									}

								} else {

								    // log
									logWrite( 'impossibile aggiornare la timestamp di invio procrastinata per la mail #' . $out['id'] . ' in mail_out', 'mail', LOG_ERR );

								    // rollback
									mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );

								}

							} else {

							    // log
								logWrite( 'impossibile riportare in mail_out la mail #' . $out['id'] . ' da mail_sent', 'mail', LOG_ERR );

							    // rollback
								mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );

							}

						    // riabilito l'autocommit
							mysqlQuery( $cf['mysql']['connection'], 'SET autocommit = 1' );

						} else {

						    // log
							logWrite( 'impossibile disabilitare il commit automatico per riportare in mail_sent la mail #' . $out['id'] . ' in OUT', 'mail', LOG_ERR );

						}

					} else {

					    // log
						logWrite( 'avviare la transazione per riportare in mail_sent la mail #' . $out['id'] . ' in OUT', 'mail', LOG_ERR );

					}

				} else {

				    // log
					logWrite( 'impossibile ottenere il lock sulle tabelle per riportare in mail_sent la mail #' . $out['id'] . ' in OUT', 'mail', LOG_ERR );

				}

			}

		}

	    // unlock delle tabelle
		mysqlQuery( $cf['mysql']['connection'], 'UNLOCK TABLES' );

	} else {

	    // log
		logWrite( 'impossibile acquisire il lock sulle tabelle di coda', 'mail', LOG_ERR );

	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

?>
