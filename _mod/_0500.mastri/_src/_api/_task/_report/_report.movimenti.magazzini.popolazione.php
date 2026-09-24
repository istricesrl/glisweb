<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( ! isset( $_REQUEST['idRiga'] ) ) {

		// trovo una riga da aggiornare
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT documenti_articoli.id FROM documenti_articoli 
            LEFT JOIN __report_movimenti_magazzini__ ON __report_movimenti_magazzini__.id = documenti_articoli.id
            WHERE (
				( 
					coalesce( documenti_articoli.timestamp_aggiornamento, documenti_articoli.timestamp_inserimento ) > __report_movimenti_magazzini__.timestamp_aggiornamento 
					OR
					coalesce( documenti_articoli.timestamp_aggiornamento, documenti_articoli.timestamp_inserimento ) IS NULL
				)
			)
            OR __report_movimenti_magazzini__.timestamp_aggiornamento IS NULL
			ORDER BY documenti_articoli.id DESC
			LIMIT 1'
		);

    } elseif( isset( $_REQUEST['idRiga'] ) ) {

        // scrivo la riga
        $status['aggiornare']['id'] = $_REQUEST['idRiga'];

	}

    // ...
    if( ! empty( $status['aggiornare']['id'] ) ) {
        updateReportMovimentiMagazzini(
            $status['aggiornare']['id']
        );
    }

    // debug
    // print_r( $_REQUEST );

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
