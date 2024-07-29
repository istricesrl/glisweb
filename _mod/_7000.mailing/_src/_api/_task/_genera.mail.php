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

    // debug
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // status
	$status['info'][] = 'inizio operazioni di generazione mail';

    // chiave di lock
	if( ! isset( $status['token'] ) ) {
	    $status['token'] = getToken( __FILE__ );
	}

    // debug
	// var_dump( $status['token'] );

    // se è specificato un ID, forzo la richiesta
    if( isset( $_REQUEST['id'] ) ) {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mailing_mail SET token = ? '.
			'WHERE id = ? AND token IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );

        // status
        $status['info'][] = 'selezione forzata';

    } else {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE mailing_mail '.
            'SET mailing_mail.token = ? '.
			'WHERE mailing_mail.timestamp_generazione IS NULL '.
            'AND token IS NULL '.
            'ORDER BY mailing_mail.id ASC '.
            'LIMIT 1',
            array(
                array( 's' => $status['token'] )
            )
	    );

        // status
        $status['info'][] = 'selezione normale';

    }

	// debug
	// print_r( $status );
	// print_r( $_REQUEST );

	// se è specificata una mail di test
	if( isset( $_REQUEST['mt'] ) && isset( $_REQUEST['mid'] ) && in_array( 'INVIO_DIRETTO_MAIL', array_keys( $_SESSION['account']['privilegi'] ) ) ) {

		// simulo l'estrazione di una riga dalla coda
		$row = array_replace_recursive(
			mysqlSelectRow(
				$cf['mysql']['connection'],
				'SELECT mailing.* '.
				'FROM mailing '.
				'WHERE id = ? ',
				array(
					array( 's' => $_REQUEST['mid'] )
				)
			),
			array(
				'indirizzo' => $_REQUEST['mt'],
				'destinatario' => 'DESTINATARIO DI TEST',
				'timestamp_invio' => time(),
				'id_mail' => NULL
			)
		);

        // status
        $status['info'][] = 'selezione diretta';

		// debug
		// print_r( $status );
		// print_r( $_REQUEST );
		// print_r( $row );
		// die();

	} else {

		// prelevo una riga dalla coda
		$row = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT mailing.*, mailing_mail.id_mail, '.
			'mail.indirizzo, anagrafica.codice AS codice_destinatario, '.
			'anagrafica.id AS id_destinatario, anagrafica.nome AS nome_destinatario, anagrafica.cognome AS cognome_destinatario, anagrafica.denominazione AS denominazione_destinatario, '.
			'concat_ws( \' \', anagrafica.nome, anagrafica.cognome, anagrafica.denominazione ) AS destinatario '.
			'FROM mailing_mail '.
			'INNER JOIN mailing ON mailing.id = mailing_mail.id_mailing '.
			'INNER JOIN mail ON mail.id = mailing_mail.id_mail '.
			'LEFT JOIN anagrafica ON anagrafica.id = mail.id_anagrafica '.
			'WHERE mailing_mail.token = ? ',
			array(
				array( 's' => $status['token'] )
			)
		);

        // status
        $status['info'][] = 'selezione da token (' . $status['token'] . ')';

        // debug
        // print_r( $row );
        // var_dump( $status['token'] );

	}


    // se c'è almeno una mail da inviare
    if( ! empty( $row ) ) {

        // debug
        // $status['info'][] = $row;
		// var_dump( $row );

		// calcolo il token di cancellazione
		$row['mtk'] = md5( $row['id_mail'].$row['indirizzo'] );

		// log
		logWrite( print_r( $row, true ), 'details/mailing/' . $row['id'], LOG_ERR );

		// inizializzo il template
		$tpl = array(
			'type' => 'twig',
			'nome' => $row['nome']
		);

		// log
		logWrite( print_r( $tpl, true ), 'details/mailing/' . $row['id'], LOG_ERR );

        // prelevo i contenuti
		$cnts = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT contenuti.*,lingue.ietf FROM contenuti '.
			'INNER JOIN lingue ON lingue.id = contenuti.id_lingua '.
			'WHERE contenuti.id_mailing = ?',
			array( array( 's' => $row['id'] ) )
		);

		// log
		logWrite( print_r( $cnts, true ), 'details/mailing/' . $row['id'], LOG_ERR );

        // debug
        // var_dump( $cnts );
        // die();

		// ciclo sui contenuti
		foreach( $cnts as $cnt ) {
			$cnt['testo'] = path2url( $cnt['testo'], 1, $row['id'], $row['id_mail'] );
			$tpl[ $cnt['ietf'] ] = array(
			'from' => array( $cnt['mittente_nome'] => $cnt['mittente_mail'] ),
			'to' => array(),
			'to_cc' => array(),
			'to_bcc' => array(),
			'oggetto' => $cnt['cappello'], // è giusto cappello?
			'testo' => $cnt['testo']
			);

            // TODO appendere automaticamente:
            // <p>ricevi questa mail perché sei iscritto alla nostra newsletter,
            // per cancellarti <a href="https://crm.eurosnodi.it/disiscrizione?mtk={{ row.mtk }}&amp;isc={{ row.id_mail }}">clicca qui</a></p>
            // se nel testo non è presente la stringa:
            // mtk={{ row.mtk }}&amp;isc={{ row.id_mail }}
            // e se sono disponibili i valori di row.mtk e row.id_mail

		}

        // debug
		// var_dump($tpl );

        // prelevo gli allegati
		$files = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT file.*,lingue.ietf FROM file '.
			'INNER JOIN lingue ON lingue.id = file.id_lingua '.
			'WHERE file.id_mailing = ?',
			array( array( 's' => $row['id'] ) )
		);

		// ciclo sugli allegati
		foreach( $files as $file ) {
			$tpl[ $file['ietf'] ]['attach'][ basename( $file['path'] ) ] = $file['path'];
		}

        // debug
		// var_dump( $tpl );
		// die();

		// log
		logWrite( print_r( $tpl, true ), 'details/mailing/' . $row['id'], LOG_ERR );

        // debug
        // die( print_r( $tpl, true ) );

		// invio la mail
		$invio = queueMailFromTemplate(
			$cf['mysql']['connection'],
			$tpl,
			array( 'row' => $row ),
			$row['timestamp_invio'],
			array( $row['destinatario'] => $row['indirizzo'] ),
			$cf['localization']['language']['ietf'],
            array(),
            array(),
            array(),
            array(
                'List-unsubscribe' => 
                    '<mailto:'.$cnt['mittente_mail'].'?subject=Unsubscribe%20:%20{'.$row['indirizzo'].'}>,'.
                    '<' . $cf['site']['url'] . 'disiscrizione?mtk=' . md5( $row['id_mail'] . $row['indirizzo'] ) . '&isc=' . $row['id_mail'] . '>',
                'List-Unsubscribe-Post' => 'List-Unsubscribe=One-Click'
            )
        );

        // TODO prelevare i dati dai metadati del mailing e inserirli come dt
        // TODO prelevare i dati del destinatario e inserirli come ds

        // debug
        // die( 'h='.$invio );

        /**
         * TODO list-unsubscribe
         * bisogna aggiungere a ogni invio di newsletter gli header per il list-unsubscribe
         * https://crm.eurosnodi.it/disiscrizione?mtk={{ row.mtk }}
         * 
         */

        // debug
        // echo 'invio';
		// var_dump( $invio );
		// die();

		// aggiorno la coda
		if( $invio ) {

			// se ho inviato dalla tabella mailing_mail
			if( isset( $status['id'] ) && ! empty( $status['id'] ) ) {

				// aggiorno la riga
				$status['id'] = mysqlQuery(
					$cf['mysql']['connection'],
					'UPDATE mailing_mail '.
					'SET mailing_mail.timestamp_generazione = ?, '.
					'mailing_mail.id_mail_out = ?, '.
					'mailing_mail.token = NULL '.
					'WHERE mailing_mail.token = ? ',
					array(
						array( 's' => time() ),
						array( 's' => $invio ),
						array( 's' => $status['token'] )
					)
				);

                // debug
				// echo 'mailing_mail aggiornata ' . $status['id'] . '<br>';

				// follow-up
				if( ! empty( $row['promemoria_id_tipologia'] ) ) {

					// follow-up
					if( ! empty( $row['id_destinatario'] ) ) {

						// inserisco il follow-up
						$status['id_follow_up'] = mysqlInsertRow(
							$cf['mysql']['connection'],
							array(
								'id_tipologia' => $row['promemoria_id_tipologia'],
								'id_cliente' => $row['id_destinatario'],
								'id_mail' => $invio,
								'id_mailing' => $row['id'],
								'id_anagrafica_programmazione' => $row['promemoria_id_anagrafica_programmazione'],
								'nome' => $row['promemoria_nome'],
								'note_programmazione' => $row['promemoria_note_programmazione'],
								'data_programmazione' => date( 'Y-m-d', strtotime( '+' . $row['promemoria_giorni_programmazione'] . ' days', $row['timestamp_invio'] ) )
							),
							'attivita'
						);

					}

				}

			}

			// status
			$status['info'][] = 'mail generata correttamente con id #' . $invio;

            // debug
            // die( 'mail generata correttamente con id #' . $invio );

		} else {

			// status
			$status['err'][] = 'impossibile generare la mail';

            // debug
            // die( 'impossibile generare la mail' );

		}
				
    } else {

        // chiudo il ciclo
        $iter = $task['iterazioni'];

		// status
        $status['info'][] = 'nessuna mail da generare';

        // log
        logWrite( 'nessuna mail da generare', 'mailer' );

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
