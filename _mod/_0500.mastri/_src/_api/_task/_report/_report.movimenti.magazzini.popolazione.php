<?php

    /**
     * Popola __report_movimenti_magazzini__, a lotti.
     *
     * Senza parametri prende le righe di documenti_articoli che nel report mancano o sono piu' vecchie
     * della riga, dalla piu' recente, e le riscrive con updateReportMovimentiMagazzini(); di solito lo chiama
     * un timer o un cron a intervalli regolari.
     *
     * Fino al 20/10/2026 lavorava UNA riga per chiamata, e non teneva il passo delle importazioni massive
     * di documenti, che portano migliaia di righe in poche ore. Con 50 righe a lotto la chiamata costa meno
     * di un secondo.
     *
     * parametro    | significato
     * -------------|------------------------------------------------------------------------------------
     * idRiga       | riscrive solo quella riga di documenti_articoli
     * limite       | quante righe per chiamata ( default 50, da 1 a 1000 )
     * completo     | se valorizzato, cerca le righe su tutta la tabella invece che dal marcatore in poi
     *
     * Dal 21/10/2026 le righe si cercano dal timestamp più alto del report in poi ( il marcatore, vedi la nota nel
     * codice ), e la ricerca usa l'indice su documenti_articoli.timestamp_aggiornamento; il giro completo resta per
     * riallineare le righe scritte con un timestamp più vecchio del marcatore.
     *
     * Restituisce in aggiornare gli id lavorati, in aggiornate quanti sono e in marcatore il timestamp usato.
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_DOCUMENTI' );

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( ! isset( $_REQUEST['idRiga'] ) ) {

		// NOTA le righe si lavorano a lotti: una per chiamata non teneva il passo delle importazioni massive,
		// che portano migliaia di righe in poche ore
		$limite = ( ! empty( $_REQUEST['limite'] ) ) ? intval( $_REQUEST['limite'] ) : 50;
		if( $limite < 1 )    { $limite = 1; }
		if( $limite > 1000 ) { $limite = 1000; }

		// NOTA il report copia il timestamp_aggiornamento della riga di documenti_articoli che riscrive, e le righe
		// si lavorano in ordine di timestamp: il timestamp piu' alto del report e' quindi il punto fino a cui le righe
		// sono gia' state lavorate, e una riga modificata dopo ha per forza un timestamp uguale o maggiore, perche'
		// lo prende al momento della scrittura. Fino al 21/10/2026 le righe da aggiornare si cercavano con un
		// anti-join su tutta documenti_articoli, che a regime la leggeva per intero per trovarne poche ( 85k righe
		// su bernispa, 0,2 s a riposo e 4-5 s con mysql03 carico ); col marcatore la ricerca e' un range sull'indice
		// di timestamp_aggiornamento. Il marcatore si legge in una query a parte perche' MySQL tratta la subquery
		// come non costante e rinuncia al range. Una riga scritta con un timestamp vecchio ( a mano, o da un server
		// con l'orologio indietro ) resta sotto il marcatore: per quei casi c'e' il giro completo con completo=1
		if( empty( $_REQUEST['completo'] ) ) {

			// timestamp fino a cui il report e' allineato
			$marcatore = mysqlSelectValue(
				$cf['mysql']['connection'],
				'SELECT coalesce( max( timestamp_aggiornamento ), 0 ) FROM __report_movimenti_magazzini__'
			);

			// trovo le righe da aggiornare dal marcatore in poi
			$status['aggiornare'] = mysqlSelectColumn(
				'id',
				$cf['mysql']['connection'],
				'SELECT documenti_articoli.id FROM documenti_articoli
				LEFT JOIN __report_movimenti_magazzini__ ON __report_movimenti_magazzini__.id = documenti_articoli.id
				WHERE documenti_articoli.timestamp_aggiornamento >= ?
				AND (
					__report_movimenti_magazzini__.timestamp_aggiornamento IS NULL
					OR
					documenti_articoli.timestamp_aggiornamento > __report_movimenti_magazzini__.timestamp_aggiornamento
				)
				ORDER BY documenti_articoli.timestamp_aggiornamento, documenti_articoli.id
				LIMIT ' . $limite,
				array( array( 's' => intval( $marcatore ) ) )
			);

			// le righe senza timestamp_aggiornamento non hanno un posto rispetto al marcatore: le lavoro a parte,
			// e updateReportMovimentiMagazzini() gli assegna il timestamp
			if( count( $status['aggiornare'] ) < $limite ) {
				$status['aggiornare'] = array_merge(
					$status['aggiornare'],
					mysqlSelectColumn(
						'id',
						$cf['mysql']['connection'],
						'SELECT id FROM documenti_articoli WHERE timestamp_aggiornamento IS NULL ORDER BY id LIMIT ' . ( $limite - count( $status['aggiornare'] ) )
					)
				);
			}

			// marcatore usato
			$status['marcatore'] = $marcatore;

		} else {

			// giro completo: tutte le righe che nel report mancano o sono piu' vecchie della riga
			$status['aggiornare'] = mysqlSelectColumn(
				'id',
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
				LIMIT ' . $limite
			);

		}

    } elseif( isset( $_REQUEST['idRiga'] ) ) {

        // scrivo la riga
        $status['aggiornare'] = array( $_REQUEST['idRiga'] );

	}

    // ...
    foreach( $status['aggiornare'] as $idRiga ) {
        if( ! empty( $idRiga ) ) {
            updateReportMovimentiMagazzini( $idRiga );
        }
    }

    // numero di righe lavorate
    $status['aggiornate'] = count( $status['aggiornare'] );

    // debug
    // print_r( $_REQUEST );

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
