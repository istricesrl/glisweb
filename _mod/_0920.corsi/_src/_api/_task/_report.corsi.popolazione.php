<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_CORSI' );

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( isset( $_REQUEST['id'] ) ) {

        // scrivo la riga
        $status['aggiornare']['id'] = $_REQUEST['id'];

	} else {
/*
		// trovo un corso da aggiornare
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT progetti.id FROM progetti 
            LEFT JOIN __report_corsi__ ON __report_corsi__.id = progetti.id
            WHERE
                ( __report_corsi__.timestamp_inserimento IS NULL OR progetti.timestamp_inserimento > __report_corsi__.timestamp_inserimento )
                OR
                ( __report_corsi__.timestamp_aggiornamento IS NULL OR progetti.timestamp_aggiornamento > __report_corsi__.timestamp_aggiornamento )
                OR
                ( __report_corsi__.timestamp_aggiornamento < from_unixtime( unix_timestamp() - 86400 * 1 ) )
			ORDER BY progetti.id DESC
			LIMIT 1'
		);
*/
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT progetti.id FROM progetti ORDER BY progetti.timestamp_aggiornamento_report_corsi ASC, progetti.id DESC LIMIT 1'
		);


	}

    // scrivo la riga
	if( ! empty( $status['aggiornare']['id'] ) ) {
		updateReportCorsi(
			$status['aggiornare']['id']
		);
		mysqlQuery(
			$cf['mysql']['connection'],
			'UPDATE progetti SET timestamp_aggiornamento_report_corsi = unix_timestamp(now()) WHERE id = ' . intval( $status['aggiornare']['id'] )
		);
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
