<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // debug
    // ini_set('display_errors', 1);
    // ini_set('display_startup_errors', 1);
    // error_reporting(E_ALL);

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( ! isset( $_REQUEST['idAttivita'] ) ) {

		// trovo una riga da aggiornare
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT attivita.id FROM attivita 
            LEFT JOIN attivita_view_static ON attivita_view_static.id = attivita.id
            WHERE
                ( attivita_view_static.timestamp_inserimento IS NULL OR attivita.timestamp_inserimento > attivita_view_static.timestamp_inserimento )
                OR
                ( attivita_view_static.timestamp_aggiornamento IS NULL OR attivita.timestamp_aggiornamento > attivita_view_static.timestamp_aggiornamento )
			ORDER BY attivita.id DESC
			LIMIT 1'
		);

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

    } elseif( isset( $_REQUEST['idAttivita'] ) ) {

        // scrivo la riga
        $status['aggiornare']['id'] = $_REQUEST['idAttivita'];
        $status['modalita'] = 'forzata';

	}

	// ...
	if( ! empty( $status['aggiornare']['id'] ) ) {
        mysqlQuery(
            $cf['mysql']['connection'],
            'REPLACE INTO attivita_view_static SELECT * FROM attivita_view WHERE id = ?',
            array(
                array( 's' => $status['aggiornare']['id'] )
            )
        );
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita_view_static SET timestamp_inserimento = unix_timestamp() WHERE id = ? AND timestamp_inserimento IS NULL',
            array(
                array( 's' => $status['aggiornare']['id'] )
            )
        );
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita_view_static SET timestamp_aggiornamento = unix_timestamp() WHERE id = ? AND timestamp_aggiornamento IS NULL',
            array(
                array( 's' => $status['aggiornare']['id'] )
            )
        );
	}

	// debug
    // print_r( $_REQUEST );

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
