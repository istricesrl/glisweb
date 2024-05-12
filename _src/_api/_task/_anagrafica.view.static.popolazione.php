<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( ! isset( $_REQUEST['idAnagrafica'] ) ) {

		// trovo una riga da aggiornare
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT anagrafica.id FROM anagrafica 
            LEFT JOIN anagrafica_view_static ON anagrafica_view_static.id = anagrafica.id
            WHERE
                ( anagrafica_view_static.timestamp_inserimento IS NULL OR anagrafica.timestamp_inserimento > anagrafica_view_static.timestamp_inserimento )
                OR
                ( anagrafica_view_static.timestamp_aggiornamento IS NULL OR anagrafica.timestamp_aggiornamento > anagrafica_view_static.timestamp_aggiornamento )
			ORDER BY anagrafica.id DESC
			LIMIT 1'
		);

        // verifico le tabelle collegate
		if( empty( $status['aggiornare'] ) ) {

			// ...
			$aggiornare = array();

			// tabelle collegate
			foreach( array( 'anagrafica_categorie' ) as $table ) {

				// trovo una riga da aggiornare
				$aggiornare[] = mysqlSelectValue(
					$cf['mysql']['connection'],
					'SELECT ' . $table . '.id_anagrafica 
					FROM ' . $table . ' 
					LEFT JOIN anagrafica_view_static ON anagrafica_view_static.id = ' . $table . '.id_anagrafica
					WHERE coalesce( ' . $table . '.timestamp_aggiornamento, ' . $table . '.timestamp_inserimento ) > anagrafica_view_static.timestamp_aggiornamento 
					OR anagrafica_view_static.timestamp_aggiornamento IS NULL
					LIMIT 1'
				);

			}

            // status
			$status['aggiornare']['id'] = max( $aggiornare );
            $status['modalita'] = 'categorie';

		} else {

            // status
            $status['modalita'] = 'standard';

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

    } elseif( isset( $_REQUEST['idAnagrafica'] ) ) {

        // scrivo la riga
        $status['aggiornare']['id'] = $_REQUEST['idAnagrafica'];
        $status['modalita'] = 'forzata';

	}

	// ...
	if( ! empty( $status['aggiornare']['id'] ) ) {
		updateAnagraficaViewStatic(
			$status['aggiornare']['id']
		);
	}

	// debug
    // print_r( $_REQUEST );

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
