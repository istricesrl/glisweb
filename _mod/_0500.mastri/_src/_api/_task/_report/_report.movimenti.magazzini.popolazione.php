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
     *
     * Restituisce in aggiornare gli id lavorati e in aggiornate quanti sono.
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( ! isset( $_REQUEST['idRiga'] ) ) {

		// NOTA le righe si lavorano a lotti: una per chiamata non teneva il passo delle importazioni massive,
		// che portano migliaia di righe in poche ore
		$limite = ( ! empty( $_REQUEST['limite'] ) ) ? intval( $_REQUEST['limite'] ) : 50;
		if( $limite < 1 )    { $limite = 1; }
		if( $limite > 1000 ) { $limite = 1000; }

		// trovo le righe da aggiornare
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
