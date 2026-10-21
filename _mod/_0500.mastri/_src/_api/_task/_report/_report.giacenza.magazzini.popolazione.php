<?php

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        require '../../../../../../_src/_config.php';
    }

    // inizializzo l'array del risultato
    $status = array();

    // ...
    if( ! isset( $_REQUEST['idArticolo'] ) && ! isset( $_REQUEST['matricola'] ) ) {

		// NOTA prima si raggruppano i movimenti e poi si fa la join col report: la join riga per riga
		// fra documenti_articoli e il report, senza indici utili, costava ~16 secondi a query
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT
				d.id_articolo,
				d.id_matricola,
				d.id_mastro,
				d.timestamp_ultimo_movimento,
				rp.id AS id_report,
				rp.timestamp_aggiornamento AS timestamp_aggiornamento_report
			FROM (
				SELECT
					da.id_articolo,
					da.id_matricola,
					da.id_mastro_provenienza AS id_mastro,
					max( coalesce( da.timestamp_aggiornamento, da.timestamp_inserimento ) ) AS timestamp_ultimo_movimento
				FROM documenti_articoli AS da
				WHERE da.id_articolo IS NOT NULL
					AND da.id_mastro_provenienza IS NOT NULL
				GROUP BY da.id_articolo, da.id_matricola, da.id_mastro_provenienza
			) AS d
			LEFT JOIN __report_giacenza_magazzini__ AS rp
				ON rp.id_articolo = d.id_articolo
				AND rp.id_mastro = d.id_mastro
				AND coalesce( d.id_matricola, "" ) = coalesce( rp.id_matricola, "" )
			WHERE rp.timestamp_aggiornamento IS NULL
				OR d.timestamp_ultimo_movimento > rp.timestamp_aggiornamento
			ORDER BY rp.timestamp_aggiornamento ASC
			LIMIT 1'
		);

		// ...
		if( empty( $status['aggiornare']['id_mastro'] ) ) {

			$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT
				d.id_articolo,
				d.id_matricola,
				d.id_mastro,
				d.timestamp_ultimo_movimento,
				rp.id AS id_report,
				rp.timestamp_aggiornamento AS timestamp_aggiornamento_report
			FROM (
				SELECT
					da.id_articolo,
					da.id_matricola,
					da.id_mastro_destinazione AS id_mastro,
					max( coalesce( da.timestamp_aggiornamento, da.timestamp_inserimento ) ) AS timestamp_ultimo_movimento
				FROM documenti_articoli AS da
				WHERE da.id_articolo IS NOT NULL
					AND da.id_mastro_destinazione IS NOT NULL
				GROUP BY da.id_articolo, da.id_matricola, da.id_mastro_destinazione
			) AS d
			LEFT JOIN __report_giacenza_magazzini__ AS rp
				ON rp.id_articolo = d.id_articolo
				AND rp.id_mastro = d.id_mastro
				AND coalesce( d.id_matricola, "" ) = coalesce( rp.id_matricola, "" )
			WHERE rp.timestamp_aggiornamento IS NULL
				OR d.timestamp_ultimo_movimento > rp.timestamp_aggiornamento
			ORDER BY rp.timestamp_aggiornamento ASC
			LIMIT 1'
			);

			// NOTA se non c'è niente di cambiato si riscrive la riga più vecchia, ma solo se ha più di un giorno:
			// senza il limite il report veniva riscritto all'infinito, ogni riga ogni pochi minuti
			if( empty( $status['aggiornare']['id_mastro'] ) ) {

				$status['aggiornare'] = mysqlSelectRow(
					$cf['mysql']['connection'],
					'SELECT
					rp.id_articolo,
					rp.id_matricola,
					rp.id_mastro
					FROM __report_giacenza_magazzini__ AS rp
					WHERE rp.id_mastro IS NOT NULL AND rp.id_articolo IS NOT NULL
						AND rp.timestamp_aggiornamento < unix_timestamp() - 86400
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
