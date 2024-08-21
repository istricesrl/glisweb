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

    /*
    $ct['etc']['coupon'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT coupon.id, coupon.sconto_fisso, coupon.id_anagrafica, 
            coalesce( sum( pagamenti.coupon_valore ), 0 ) AS utilizzato, ( coupon.sconto_fisso - coalesce( sum( pagamenti.coupon_valore ), 0 ) ) AS residuo
        FROM coupon 
        LEFT JOIN pagamenti ON coupon.id = pagamenti.id_coupon
        WHERE ( coupon.timestamp_inizio IS NULL OR coupon.timestamp_inizio <= NOW() )
        AND ( coupon.timestamp_fine IS NULL OR coupon.timestamp_fine >= NOW() )
        AND ( coupon.id_anagrafica = ? OR coupon.id_anagrafica IS NULL )
        GROUP BY coupon.id
        HAVING utilizzato < coupon.sconto_fisso
        ORDER BY coupon.id 
        ',
        array(
            array( 's' => $cf['session']['account']['id_anagrafica'] )
        )
    );
    */

    $ct['etc']['coupon']['disponibili'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT
            t.id,
            t.id_referenza,
            t.tipologia,
            count( t.id ) AS numero_utilizzi,
            sum( t.coupon_valore ) AS utilizzato,
            ( coupon.sconto_fisso - sum( t.coupon_valore ) ) AS residuo,
            coupon.sconto_fisso,
            coupon.timestamp_fine

        FROM (

            SELECT
            carrelli_articoli.id_coupon AS id,
            carrelli_articoli.id AS id_referenza,
            "carrello" AS tipologia,
            carrelli_articoli.coupon_valore
            FROM carrelli_articoli
            WHERE id_coupon IS NOT NULL

            UNION

            SELECT
            pagamenti.id_coupon AS id,
            pagamenti.id AS id_referenza,
            "pagamento" AS tipologia,
            pagamenti.coupon_valore
            FROM pagamenti
            WHERE id_coupon IS NOT NULL

            ) AS t
        INNER JOIN coupon ON coupon.id = t.id
        WHERE ( coupon.timestamp_inizio IS NULL OR coupon.timestamp_inizio <= NOW() )
        AND ( coupon.timestamp_fine IS NULL OR coupon.timestamp_fine >= NOW() )
        AND ( coupon.id_anagrafica = ? OR coupon.id_anagrafica IS NULL )
        GROUP BY t.id 
        HAVING residuo > 0
        ',
        array(
            array( 's' => $cf['session']['account']['id_anagrafica'] )
        )
    );

    // ...
    $ct['etc']['coupon']['utilizzati'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT id_coupon FROM carrelli_articoli WHERE id_carrello = ? AND id_coupon IS NOT NULL',
        array(
            array( 's' => $cf['session']['carrello']['id'] )
        )
    );

    // debug
    // echo( $cf['session']['account']['id_anagrafica'] ) . PHP_EOL;
    // die( print_r( $ct['etc']['coupon'], true ) );
