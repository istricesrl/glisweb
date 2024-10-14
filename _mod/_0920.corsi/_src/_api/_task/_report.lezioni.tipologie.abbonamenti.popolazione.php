<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( isset( $_REQUEST['id'] ) ) {

		// ...
        $status['aggiornare']['id'] = $_REQUEST['id'];

	} else {

		// trovo una riga da aggiornare
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT todo.id FROM todo
			INNER JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia AND tipologie_todo.id_genitore = 6
            LEFT JOIN __report_lezioni_tipologie_abbonamenti__ ON __report_lezioni_tipologie_abbonamenti__.id_todo = todo.id
            WHERE ( 
				(
					(
						coalesce( todo.timestamp_aggiornamento, todo.timestamp_inserimento ) > __report_lezioni_tipologie_abbonamenti__.timestamp_aggiornamento 
						OR
						coalesce( todo.timestamp_aggiornamento, todo.timestamp_inserimento ) IS NULL
					)
				)
				OR __report_lezioni_tipologie_abbonamenti__.timestamp_aggiornamento IS NULL
			) AND todo.data_programmazione >= NOW()
			ORDER BY todo.id DESC
			LIMIT 1'
		);

		// ...
		if( empty( $status['aggiornare'] ) ) {

            // ...
            mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE __report_lezioni_tipologie_abbonamenti__ FROM __report_lezioni_tipologie_abbonamenti__
                INNER JOIN tipologie_contratti ON tipologie_contratti.id = __report_lezioni_tipologie_abbonamenti__.id_tipologia_contratti
                WHERE tipologie_contratti.timestamp_aggiornamento > __report_lezioni_tipologie_abbonamenti__.timestamp_aggiornamento'
            );

        }

	}

	// ...
	if( ! empty( $status['aggiornare']['id'] ) ) {
		updateReportLezioniTipologieAbbonamenti(
			$status['aggiornare']['id']
		);
	}

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
