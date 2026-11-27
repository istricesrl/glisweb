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
		// trovo un corso cambiato dopo la sua riga di report, o che la riga non ce l'ha; fino al 2026-10-26 il task
		// girava a rotazione su tutti i progetti con la colonna progetti.timestamp_aggiornamento_report_corsi, uscita
		// perche' fuori canone: i valori che cambiano con la data li rifa' ogni notte il job, lanciato dal cron con
		// report.corsi.popolazione.start
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT progetti.id FROM progetti
			LEFT JOIN __report_corsi__ ON __report_corsi__.id = cast( progetti.id as char character set utf8 )
			WHERE (
				coalesce( progetti.timestamp_aggiornamento, progetti.timestamp_inserimento ) > __report_corsi__.timestamp_aggiornamento
				OR __report_corsi__.timestamp_aggiornamento IS NULL
			)
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
