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
		// Fix 2026-07-29 (Polisportiva Masi): aggiunto `cast( todo.id as char )` nella ON del LEFT
		// JOIN. `todo.id` è int mentre `__report_lezioni_corsi__.id` è char(255): senza cast MySQL
		// converte a numero la PK del report, che diventa inutilizzabile, e il join degenera in una
		// scansione completa del report per ogni riga di todo. Il caso peggiore è proprio quello a
		// regime (nessuna riga da aggiornare): si scorre tutto todo e per ognuna si scansiona tutto
		// il report. EXPLAIN: da `ALL` a `eq_ref` su PRIMARY. Misurato con 32k righe di todo e 32k
		// di report: query interrotta dopo 140 s senza completare, contro 0,5 s con il cast, a
		// parità di risultato.
		// Stesso difetto nei due blocchi commentati sopra e sotto (righe 28 e 75): se si riattivano,
		// va aggiunto lì lo stesso cast.
		// NB: modifica a un file FRAMEWORK, sarà persa al prossimo `_gw.upgrade.sh`.
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT todo.id FROM todo
			INNER JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia AND tipologie_todo.id_genitore = 6
			LEFT JOIN __report_lezioni_corsi__ ON __report_lezioni_corsi__.id = cast( todo.id as char )
			WHERE (
				coalesce( todo.timestamp_aggiornamento, todo.timestamp_inserimento ) > __report_lezioni_corsi__.timestamp_aggiornamento
				OR __report_lezioni_corsi__.timestamp_aggiornamento IS NULL
			) AND todo.id_progetto IS NOT NULL
			ORDER BY todo.id DESC
			LIMIT 1'
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
