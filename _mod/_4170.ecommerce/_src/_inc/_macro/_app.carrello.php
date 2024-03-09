<?php

    /**
     * 
     * 
     * 
     * 
     */

    // debug
    // print_r( $_REQUEST );

    /* NOTA l'app carrello deve fare tutto con la controller standard

    // se sto acquistando un abbonamento
    if( isset( $_REQUEST['__acquista_abbonamento__']['id_articolo'] ) ) {

        // trovo la tipologia di contratto a partire dall'articolo
        $tipologiaContratto = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT tipologie_contratti.*
                FROM articoli
                INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto
                INNER JOIN tipologie_contratti ON tipologie_contratti.id_prodotto = prodotti.id
                WHERE articoli.id = ?',
                array(
                    array( 's' => $_REQUEST['__acquista_abbonamento__']['id_articolo'] )
                )
        );

        // trovo la periodicità in base all'articolo
        $periodicita = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT periodicita.*
                FROM articoli
                INNER JOIN periodicita ON periodicita.id = articoli.id_periodicita
                WHERE articoli.id = ?',
                array(
                    array( 's' => $_REQUEST['__acquista_abbonamento__']['id_articolo'] )
                )
        );

        // se la data di inizio non è impostata, parto da oggi
        if( ! isset( $_REQUEST['__acquista_abbonamento__']['data_inizio'] ) ) {
            $_REQUEST['__acquista_abbonamento__']['data_inizio'] = date( 'Y-m-d' );
        }

        // il cliente è l'anagrafica attualmente connessa
        $_REQUEST['__acquista_abbonamento__']['id_anagrafica_collegata'] = $cf['session']['id_anagrafica'];

    }

    */
