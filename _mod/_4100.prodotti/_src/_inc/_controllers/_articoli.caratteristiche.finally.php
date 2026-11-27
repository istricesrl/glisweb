<?php

    /**
     * controller finally per la tabella articoli_caratteristiche
     *
     * Dopo ogni scrittura o cancellazione su articoli_caratteristiche rigenera nella vista statica articoli_view_static
     * l'articolo collegato, perché la vista porta le caratteristiche dell'articolo ( nel nome e nella tipologia di
     * listino ). L'articolo si ricava da $befores e da $vs come in _prodotti.categorie.finally.php, perché nessuna delle
     * due fonti c'è sempre.
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

            // articoli toccati dalla scrittura
            $idArticoli = array_values( array_unique( array_filter( array(
                ( isset( $befores['id_articolo'] ) ) ? $befores['id_articolo'] : NULL,
                ( isset( $vs['id_articolo']['s'] ) ) ? $vs['id_articolo']['s'] : NULL
            ) ) ) );

            // aggiornamento della vista statica
            if( ! empty( $idArticoli ) ) {
                refreshStaticView( $c, 'articoli', $idArticoli );
                logWrite( "controller finally per $t/$a aggiornata la vista statica per gli articoli #" . implode( ', #', $idArticoli ), 'controller' );
            }

        break;

    }
