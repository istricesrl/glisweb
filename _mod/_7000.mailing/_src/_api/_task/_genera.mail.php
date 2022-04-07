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
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // status
	$status['info'][] = 'inizio operazioni di generazione mail';

    // chiave di lock
	$status['token'] = getToken( __FILE__ );

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

    }

    // prelevo una riga dalla coda
    $row = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT mailing.*, '.
		'mail.indirizzo, concat_ws( \' \', anagrafica.nome, anagrafica.cognome, anagrafica.denominazione ) AS destinatario '.
        'FROM mailing_mail '.
		'INNER JOIN mailing ON mailing.id = mailing_mail.id_mailing '.
		'INNER JOIN mail ON mail.id = mailing_mail.id_mail '.
		'INNER JOIN anagrafica ON anagrafica.id = mail.id_anagrafica '.
        'WHERE token = ? ',
        array(
			array( 's' => $status['token'] )
		)
    );

    // se c'è almeno una mail da inviare
    if( ! empty( $row ) ) {

		// inizializzo il template
		$tpl = array(
			'type' => 'twig',
			'nome' => $row['nome']
		);

		// prelevo i contenuti
		$cnts = mysqlCachedQuery(
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT contenuti.*,lingue.ietf FROM contenuti '.
			'INNER JOIN lingue ON lingue.id = contenuti.id_lingua '.
			'WHERE contenuti.id_mailing = ?',
			array( array( 's' => $row['id'] ) )
		);

		// ciclo sui contenuti
		foreach( $cnts as $cnt ) {
			$tpl[ $cnt['ietf'] ] = array(
			'from' => array( $cnt['mittente_nome'] => $cnt['mittente_mail'] ),
# dopo		'to' => array( $row['destinatario'] => $row['indirizzo'] ),
			'to' => array(),
# prelevare dall'invio				'to_cc' => array( $cnt['destinatario_cc_nome'] => $cnt['destinatario_cc_mail'] ),
			'to_cc' => array(),
# prelevare dall'invio				'to_bcc' => array( $cnt['destinatario_ccn_nome'] => $cnt['destinatario_ccn_mail'] ),
			'to_bcc' => array(),
			'oggetto' => $cnt['cappello'], // è giusto cappello?
			'testo' => $cnt['testo']
			);
		}

		// prelevo gli allegati
		$files = mysqlCachedQuery(
			$cf['memcache']['connection'],
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

		// invio la mail
		$invio = queueMailFromTemplate(
			$cf['mysql']['connection'],
			$tpl,
# TODO prelevare i dati dai metadati del mailing e inserirli come dt
# TODO prelevare i dati del destinatario e inserirli come ds
			array(),
			$row['timestamp_invio'],
			array( $row['destinatario'] => $row['indirizzo'] ),
			$cf['localization']['language']['ietf']
		);

		// aggiorno la coda
		if( $invio ) {

			// aggiorno la riga
			$status['id'] = mysqlQuery(
				$cf['mysql']['connection'],
				'UPDATE mailing_mail '.
				'SET mailing_mail.timestamp_generazione = ?, '.
				'mailing_mail.id_mail_out = ?, '.
				'token = NULL '.
				'WHERE token = ? ',
				array(
					array( 's' => time() ),
					array( 's' => $invio ),
					array( 's' => $status['token'] )
				)
			);
			
		} else {

			// status
			$status['err'][] = 'impossibile generare la mail';

		}
				
    } else {

        // status
        $status['info'][] = 'nessuna mail da generare';

        // log
        logWrite( 'nessuna mail da generare', 'mailer' );

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
