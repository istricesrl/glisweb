<?php

    /**
     * macro della scheda pubblica di un ARTICOLO
     *
     * Gemella di _prodotti.scheda.php, con la regola del ripiego: quello che l'articolo ha se lo
     * tiene, quello che non ha lo prende dal suo prodotto. E' la regola del modello a tre tipologie
     * approvato il 05/09/2026 ( macchina base, opzione, macchina configurata ).
     *
     * ANCHE LE CARATTERISTICHE SONO IN RIPIEGO: prima quelle dell'articolo, e se l'articolo non ne
     * ha si sale al prodotto. Fino all'08/09/2026 non era possibile, perche' articoli_caratteristiche
     * aveva valore decimal(5,2) e nessuna lingua: non ci stava ne' un testo ne' una traduzione.
     * Adesso quella tabella e' allineata a prodotti_caratteristiche
     * ( var/database/patch.articoli.caratteristiche.20260908.sql ), quindi due configurazioni dello
     * stesso modello possono avere schede tecniche diverse.
     *
     * @file
     *
     */

    if( ! empty( $ct['page']['metadati']['id_articolo'] ) ) {

        // l'articolo e il suo prodotto
        $idArticolo = $ct['page']['metadati']['id_articolo'];
        $idProdotto = ( ! empty( $ct['page']['metadati']['id_prodotto'] ) )
            ? $ct['page']['metadati']['id_prodotto']
            : mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT id_prodotto FROM articoli WHERE id = ?',
                array( array( 's' => $idArticolo ) )
            );

        /**
         * l'albero delle caratteristiche
         *
         * Stessa costruzione di _prodotti.scheda.php: prima le radici che questo prodotto ha
         * valorizzato, poi i figli, e il genitore si legge una volta sola per non perderne il
         * valore ( un gruppo puo' avere un valore suo: e' li' che finiscono le voci di elenco
         * senza etichetta, per esempio gli accessori in dotazione ).
         */
        $ct['page']['contents']['caratteristiche'] = array();

        // l'articolo ha caratteristiche sue? se si' si legge da li', altrimenti dal prodotto
        $sueProprie = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id FROM articoli_caratteristiche WHERE id_articolo = ? LIMIT 1',
            array( array( 's' => $idArticolo ) )
        );

        if( ! empty( $sueProprie ) ) {
            $tabella = 'articoli_caratteristiche';
            $campo = 'id_articolo';
            $chiave = $idArticolo;
        } else {
            $tabella = 'prodotti_caratteristiche';
            $campo = 'id_prodotto';
            $chiave = $idProdotto;
        }

        /**
         * FUORI LA CLASSIFICAZIONE DI LISTINO
         *
         * se_articolo = 1 marca le caratteristiche che CLASSIFICANO un articolo invece di
         * descrivere la macchina: sono i due alberi che scrive l'importazione dei listini,
         * "TIPO DI VOCE A LISTINO" ( macchina base / opzione / macchina configurata ) e
         * "GRUPPO DI LISTINO" ( basamento, lunette, torretta... ). Servono al gestionale e al PDF
         * dell'offerta; sulla scheda pubblica sarebbero gergo interno, e dopo la migrazione
         * dell'08/09/2026 comparivano davvero, in fondo alle caratteristiche tecniche di tutte e
         * 349 le macchine.
         */
        $caratteristiche = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT caratteristiche_prodotti.*, ' . $tabella . '.valore FROM ' . $tabella . '
            LEFT JOIN caratteristiche_prodotti ON ( caratteristiche_prodotti.id = ' . $tabella . '.id_caratteristica )
            WHERE ' . $tabella . '.' . $campo . ' = ? AND caratteristiche_prodotti.id_genitore IS NULL
            AND COALESCE( caratteristiche_prodotti.se_articolo, 0 ) = 0 ',
            array(
                array( 's' => $chiave )
            )
        );

        foreach( $caratteristiche as $k => $c ) {

            $ct['page']['contents']['caratteristiche'][ $c['id'] ] = $c;

        }

        $figli = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT caratteristiche_prodotti.*, ' . $tabella . '.valore FROM ' . $tabella . '
            INNER JOIN caratteristiche_prodotti ON ( caratteristiche_prodotti.id = ' . $tabella . '.id_caratteristica )
            WHERE ' . $tabella . '.' . $campo . ' = ? AND caratteristiche_prodotti.id_genitore IS NOT NULL
            AND COALESCE( caratteristiche_prodotti.se_articolo, 0 ) = 0 ',
            array(
                array( 's' => $chiave )
            )
        );

        foreach( $figli as $k => $c ) {

            if( ! empty( $c['id_genitore'] ) && ! isset( $ct['page']['contents']['caratteristiche'][ $c['id_genitore'] ] ) ) {
                $ct['page']['contents']['caratteristiche'][ $c['id_genitore'] ] = mysqlSelectRow(
                    $cf['mysql']['connection'],
                    'SELECT * FROM caratteristiche_prodotti WHERE id = ? ',
                    array(
                        array( 's' => $c['id_genitore'] )
                    )
                );
            }

        }

        foreach( $figli as $k => $c ) {
            if( ! empty( $c['id_genitore'] ) ) {
                $ct['page']['contents']['caratteristiche'][ $c['id_genitore'] ]['caratteristiche'][ $c['id'] ] = $c;
            }
        }

    }
