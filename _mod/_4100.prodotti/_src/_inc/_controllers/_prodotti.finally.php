<?php

    /**
     * controller finally per la tabella prodotti
     *
     * Dopo ogni scrittura o cancellazione su prodotti rigenera nella vista statica articoli_view_static gli articoli del
     * prodotto, perché la vista porta i dati del prodotto ( nome, categorie, data di archiviazione ). Gli articoli si
     * cercano anche nella statica: dopo una cancellazione articoli.id_prodotto è già NULL ( articoli_ibfk_01_nofollow,
     * ON DELETE SET NULL ), e l'unico posto dove resta il legame col prodotto è la riga vecchia della statica.
     *
     * @file
     *
     */

    // log
    logWrite( "controller finally per $t/$a", 'controller' );

    // elaborazioni di default dei dati
    switch( strtoupper( $a ) ) {

        case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:
        case METHOD_DELETE:

            // la statica degli articoli, se il deploy ce l'ha
            if( ! empty( $d['id'] ) && getStaticView( $mc, $c, 'articoli' ) ) {

                // articoli del prodotto, nella tabella e nella statica
                $idArticoli = mysqlSelectColumn( 'id', $c,
                    'SELECT id FROM articoli WHERE id_prodotto = ? UNION SELECT id FROM articoli_view_static WHERE id_prodotto = ?',
                    array( array( 's' => $d['id'] ), array( 's' => $d['id'] ) )
                );

                // aggiornamento della vista statica
                if( ! empty( $idArticoli ) ) {
                    refreshStaticView( $c, 'articoli', $idArticoli );
                    logWrite( "controller finally per $t/$a aggiornata la vista statica per gli articoli del prodotto #" . $d['id'], 'controller' );
                }

            }

        break;

    }
