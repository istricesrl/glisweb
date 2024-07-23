<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( isset( $_REQUEST['id'] ) ) {

        // scrivo la riga
        $status['aggiornare']['id'] = $_REQUEST['id'];

	} else {

		// trovo un corso da aggiornare
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT progetti.id FROM progetti 
            LEFT JOIN __report_corsi__ ON __report_corsi__.id = progetti.id
            WHERE
                ( __report_corsi__.timestamp_inserimento IS NULL OR progetti.timestamp_inserimento > __report_corsi__.timestamp_inserimento )
                OR
                ( __report_corsi__.timestamp_aggiornamento IS NULL OR progetti.timestamp_aggiornamento > __report_corsi__.timestamp_aggiornamento )
			ORDER BY progetti.id DESC
			LIMIT 1'
		);


	}

    // scrivo la riga
	if( ! empty( $status['aggiornare']['id'] ) ) {
		updateReportCorsi(
			$status['aggiornare']['id']
		);
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
