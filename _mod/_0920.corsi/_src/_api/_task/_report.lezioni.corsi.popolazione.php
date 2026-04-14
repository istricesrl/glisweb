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

		// debug
		// die( 'Debug: in ricerca di righe da aggiornare' );
/*
		// trovo una riga da aggiornare
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT todo.id FROM todo
			INNER JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia AND tipologie_todo.id_genitore = 6
			-- INNER JOIN progetti ON progetti.id = todo.id_progetto
            LEFT JOIN __report_lezioni_corsi__ ON __report_lezioni_corsi__.id = todo.id
            WHERE (
                (
                    (
                        coalesce( todo.timestamp_aggiornamento, todo.timestamp_inserimento ) > __report_lezioni_corsi__.timestamp_aggiornamento 
                        OR
                        coalesce( todo.timestamp_aggiornamento, todo.timestamp_inserimento ) IS NULL
                        -- OR
                        -- coalesce( todo.timestamp_aggiornamento, todo.timestamp_inserimento ) < from_unixtime( unix_timestamp() - 86400 * 7 )
                    )
                )
			    OR __report_lezioni_corsi__.timestamp_aggiornamento IS NULL
            ) AND todo.id_progetto IS NOT NULL
			ORDER BY todo.id DESC
			LIMIT 1'
		);
*/
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			// 'SELECT todo.id FROM todo ORDER BY todo.timestamp_aggiornamento_report_corsi ASC DESC LIMIT 1'
			'SELECT todo.id FROM todo ORDER BY todo.timestamp_aggiornamento_report_corsi ASC LIMIT 1'
		);

		// debug
		// die( 'Aggiornare: ' . print_r( $status['aggiornare'], true ) );
/*
		// ...
		if( empty( $status['aggiornare'] ) ) {

			// ...
			$aggiornare = array();

			// tabelle collegate
			foreach( array( 'attivita' ) as $table ) {

				// trovo una riga da aggiornare
				$aggiornare[] = mysqlSelectValue(
					$cf['mysql']['connection'],
					'SELECT ' . $table . '.id_todo 
					FROM ' . $table . ' 
					LEFT JOIN __report_lezioni_corsi__ ON __report_lezioni_corsi__.id = ' . $table . '.id_todo
					LEFT JOIN todo ON todo.id = ' . $table . '.id_todo
					LEFT JOIN progetti ON progetti.id = todo.id_progetto
					WHERE (
						(
							coalesce( ' . $table . '.timestamp_aggiornamento, ' . $table . '.timestamp_inserimento ) > __report_lezioni_corsi__.timestamp_aggiornamento 
							OR
							coalesce( ' . $table . '.timestamp_aggiornamento, ' . $table . '.timestamp_inserimento ) IS NULL
						)
						OR __report_lezioni_corsi__.timestamp_aggiornamento IS NULL
					) AND progetti.id IS NOT NULL
					LIMIT 1'
				);

			}
			// ...
			// print_r( $aggiornare );

			// ...
			$status['aggiornare']['id'] = max( $aggiornare );

		}
*/

	}

	// debug
	// die( 'Aggiornare: ' . print_r( $status['aggiornare'], true ) );

	// ...
	if( ! empty( $status['aggiornare']['id'] ) ) {
		updateReportLezioniCorsi(
			$status['aggiornare']['id']
		);
		mysqlQuery(
			$cf['mysql']['connection'],
			'UPDATE todo SET timestamp_aggiornamento_report_corsi = unix_timestamp(now()) WHERE id = ' . intval( $status['aggiornare']['id'] )
		);
	}

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
