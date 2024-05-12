<?php

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        require '../../../../../../_src/_config.php';
    }

    // inizializzo l'array del risultato
    $status = array();

    // ...
    if( ! isset( $_REQUEST['idArticolo'] ) && ! isset( $_REQUEST['matricola'] ) ) {

	/*

	// trovo una riga da aggiornare
	$status['aggiornare'] = mysqlSelectRow(
	    $cf['mysql']['connection'],
	    'SELECT t.* FROM (

		SELECT
				da.id_articolo,
				da.id_matricola,
				da.id_mastro_provenienza AS id_mastro,
				max( coalesce( da.timestamp_aggiornamento, da.timestamp_inserimento ) ) AS timestamp_ultimo_movimento,
				rp.id AS id_report,
				max( rp.timestamp_aggiornamento ) AS timestamp_aggiornamento_report
			    FROM documenti_articoli AS da
			    LEFT JOIN __report_giacenza_magazzini__ AS rp
				ON rp.id_articolo = da.id_articolo
				AND rp.id_mastro = da.id_mastro_provenienza
				AND coalesce( da.id_matricola, "" ) = coalesce( rp.id_matricola, "" )
			    GROUP BY da.id_articolo, da.id_matricola, da.id_mastro_provenienza
		
		
		UNION
		
		SELECT
				da.id_articolo,
				da.id_matricola,
				da.id_mastro_destinazione AS id_mastro,
				max( coalesce( da.timestamp_aggiornamento, da.timestamp_inserimento ) ) AS timestamp_ultimo_movimento,
				rp.id AS id_report,
				max( rp.timestamp_aggiornamento ) AS timestamp_aggiornamento_report
			    FROM documenti_articoli AS da
			    LEFT JOIN __report_giacenza_magazzini__ AS rp
				ON rp.id_articolo = da.id_articolo
				AND rp.id_mastro = da.id_mastro_destinazione
				AND coalesce( da.id_matricola, "" ) = coalesce( rp.id_matricola, "" )
			    GROUP BY da.id_articolo, da.id_matricola, da.id_mastro_destinazione
		
		
		
		) AS t
		
			    GROUP BY t.id_articolo, t.id_matricola, t.id_mastro
			      HAVING timestamp_ultimo_movimento > timestamp_aggiornamento_report OR timestamp_aggiornamento_report IS NULL
		AND t.id_mastro IS NOT NULL
			    ORDER BY timestamp_aggiornamento_report ASC
		
	    LIMIT 1'
	);

	*/

	$status['aggiornare'] = mysqlSelectRow(
	    $cf['mysql']['connection'],
	    'SELECT
		da.id_articolo,
		da.id_matricola,
		da.id_mastro_provenienza AS id_mastro,
		max( coalesce( da.timestamp_aggiornamento, da.timestamp_inserimento ) ) AS timestamp_ultimo_movimento,
		rp.id AS id_report,
		max( rp.timestamp_aggiornamento ) AS timestamp_aggiornamento_report
	    FROM documenti_articoli AS da
	    LEFT JOIN __report_giacenza_magazzini__ AS rp
		ON rp.id_articolo = da.id_articolo
		AND rp.id_mastro = da.id_mastro_provenienza
		AND coalesce( da.id_matricola, "" ) = coalesce( rp.id_matricola, "" )
		WHERE da.id_articolo IS NOT NULL
	    GROUP BY da.id_articolo, da.id_matricola, da.id_mastro_provenienza
	    HAVING timestamp_ultimo_movimento > timestamp_aggiornamento_report OR timestamp_aggiornamento_report IS NULL
		AND da.id_mastro_provenienza IS NOT NULL
	    ORDER BY timestamp_aggiornamento_report ASC
	    LIMIT 1'
	);

	// ...
	if( empty( $status['aggiornare']['id_mastro'] ) ) {

	    $status['aggiornare'] = mysqlSelectRow(
		$cf['mysql']['connection'],
		'SELECT
		    da.id_articolo,
		    da.id_matricola,
		    da.id_mastro_destinazione AS id_mastro,
		    max( coalesce( da.timestamp_aggiornamento, da.timestamp_inserimento ) ) AS timestamp_ultimo_movimento,
		    rp.id AS id_report,
		    max( rp.timestamp_aggiornamento ) AS timestamp_aggiornamento_report
		FROM documenti_articoli AS da
		LEFT JOIN __report_giacenza_magazzini__ AS rp
		    ON rp.id_articolo = da.id_articolo
		    AND rp.id_mastro = da.id_mastro_destinazione
		    AND coalesce( da.id_matricola, "" ) = coalesce( rp.id_matricola, "" )
		WHERE da.id_articolo IS NOT NULL
		GROUP BY da.id_articolo, da.id_matricola, da.id_mastro_destinazione
		HAVING timestamp_ultimo_movimento > timestamp_aggiornamento_report OR timestamp_aggiornamento_report IS NULL
		    AND da.id_mastro_destinazione IS NOT NULL
		ORDER BY timestamp_aggiornamento_report ASC
		LIMIT 1'
	    );

	    if( empty( $status['aggiornare']['id_mastro'] ) ) {

		$status['aggiornare'] = mysqlSelectRow(
		    $cf['mysql']['connection'],
		    'SELECT
			rp.id_articolo,
			rp.id_matricola,
			rp.id_mastro
		    FROM __report_giacenza_magazzini__ AS rp
		    WHERE rp.id_mastro IS NOT NULL AND rp.id_articolo IS NOT NULL
		    ORDER BY rp.timestamp_aggiornamento ASC
		    LIMIT 1'
		);

	    }

	}

	// ...
	if( ! empty( $status['aggiornare']['id_mastro'] ) ) {
	    updateReportGiacenzaMagazzini(
		$status['aggiornare']['id_mastro'],
		$status['aggiornare']['id_articolo'],
		$status['aggiornare']['id_matricola']
	    );
	}
/*
	// ...
	if( ! empty( $status['aggiornare']['id_mastro_destinazione'] ) ) {
	    updateReportGiacenzaMagazzini(
		$status['aggiornare']['id_mastro_destinazione'],
		$status['aggiornare']['id_articolo'],
		$status['aggiornare']['id_matricola']
	    );
	}
*/

    } elseif( isset( $_REQUEST['idMastro'] ) && isset( $_REQUEST['idArticolo'] ) && isset( $_REQUEST['matricola'] ) ) {

	// scrivo la riga
	updateReportGiacenzaMagazzini( $_REQUEST['idMastro'], $_REQUEST['idArticolo'], $_REQUEST['matricola'] );

    } elseif( isset( $_REQUEST['idMastro'] ) && isset( $_REQUEST['matricola'] ) ) {

        // TODO ricavo l'articolo dalla matricola

        // TODO scrivo la riga

    } elseif( isset( $_REQUEST['idMastro'] ) && isset( $_REQUEST['idArticolo'] ) ) {

        // scrivo la riga
	updateReportGiacenzaMagazzini( $_REQUEST['idMastro'], $_REQUEST['idArticolo'] );

    }

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
