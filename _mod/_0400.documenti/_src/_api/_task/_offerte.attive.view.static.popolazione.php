<?php

    /**
     * popolamento della vista statica delle offerte
     *
     * Gemello di _mod/_0200.attivita/_src/_api/_task/_attivita.view.static.popolazione.php: cerca
     * UNA riga rimasta indietro e la riscrive. Va richiamato in ciclo ( il pulsante della scheda
     * strumenti delle offerte usa lws, che lo ripete finche' c'e' da fare ).
     *
     * A tenere allineata la statica, di norma, e' il controller finally dei documenti: questo task
     * serve per le righe che entrano in archivio SENZA passare dal controller - l'importazione dei
     * preventivi dal vecchio gestionale, per esempio - e per la prima popolazione.
     *
     * COME SI CAPISCE CHE UNA RIGA E' INDIETRO: offerte_attive_view i timestamp non li espone,
     * quindi nella statica arrivano NULL. Il task li confronta con quelli di documenti e, dopo aver
     * riscritto la riga, timbra quelli ancora NULL con l'ora corrente: e' lo stesso meccanismo del
     * task delle attivita', ed e' quello che fa terminare il ciclo.
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_MYSQL' );

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( ! isset( $_REQUEST['idDocumento'] ) ) {

		// trovo una riga da aggiornare
		$status['aggiornare'] = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT documenti.id FROM documenti
            INNER JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
            LEFT JOIN offerte_attive_view_static ON offerte_attive_view_static.id = documenti.id
            WHERE
                tipologie_documenti.se_offerta IS NOT NULL
                AND (
                    ( offerte_attive_view_static.timestamp_inserimento IS NULL OR documenti.timestamp_inserimento > offerte_attive_view_static.timestamp_inserimento )
                    OR
                    ( offerte_attive_view_static.timestamp_aggiornamento IS NULL OR documenti.timestamp_aggiornamento > offerte_attive_view_static.timestamp_aggiornamento )
                )
			ORDER BY documenti.id DESC
			LIMIT 1'
		);

    } elseif( isset( $_REQUEST['idDocumento'] ) ) {

        // scrivo la riga
        $status['aggiornare']['id'] = $_REQUEST['idDocumento'];
        $status['modalita'] = 'forzata';

	}

	// ...
	if( ! empty( $status['aggiornare']['id'] ) ) {

        // la riga vecchia si toglie prima, perche' un documento puo' essere USCITO dalla vista
        // restando in archivio ( tipologia o emittente cambiati ) e la REPLACE non se ne
        // accorgerebbe: e' la stessa ragione del controller finally
        mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM offerte_attive_view_static WHERE id = ?',
            array(
                array( 's' => $status['aggiornare']['id'] )
            )
        );

        refreshStaticView( $cf['mysql']['connection'], 'offerte_attive', $status['aggiornare']['id'] );

        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE offerte_attive_view_static SET timestamp_inserimento = unix_timestamp() WHERE id = ? AND timestamp_inserimento IS NULL',
            array(
                array( 's' => $status['aggiornare']['id'] )
            )
        );
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE offerte_attive_view_static SET timestamp_aggiornamento = unix_timestamp() WHERE id = ? AND timestamp_aggiornamento IS NULL',
            array(
                array( 's' => $status['aggiornare']['id'] )
            )
        );

	}

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
