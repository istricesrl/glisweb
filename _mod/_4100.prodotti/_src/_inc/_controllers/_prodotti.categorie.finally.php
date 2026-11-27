<?php

    /**
     * controller finally per la tabella prodotti_categorie
     *
     * Dopo ogni scrittura o cancellazione su prodotti_categorie rigenera nella vista statica articoli_view_static gli
     * articoli del prodotto collegato, perché la vista porta le categorie del prodotto ( colonne id_categorie e
     * categorie ). Il modello è _anagrafica.categorie.finally.php dello standard.
     *
     * quale prodotto
     * ==============
     * Il prodotto si ricava da due fonti, perché nessuna delle due c'è sempre:
     *
     * fonte                        | quando c'è
     * -----------------------------|-------------------------------------------------------------------------------
     * $befores['id_prodotto']      | la riga com'era prima della query: controller() la legge solo per PUT, REPLACE,
     *                              | UPDATE e DELETE di una riga con id, quindi manca su un POST ( riga nuova )
     * $vs['id_prodotto']['s']      | il valore scritto dalla query, con __parent_id__ già sostituito e l'eventuale
     *                              | codice_prodotto già convertito dal controller before: manca su un DELETE
     *
     * Se le due fonti danno prodotti diversi si aggiornano gli articoli di tutti e due.
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

            // prodotti toccati dalla scrittura
            $idProdotti = array_unique( array_filter( array(
                ( isset( $befores['id_prodotto'] ) ) ? $befores['id_prodotto'] : NULL,
                ( isset( $vs['id_prodotto']['s'] ) ) ? $vs['id_prodotto']['s'] : NULL
            ) ) );

            // aggiornamento della vista statica per gli articoli dei prodotti
            foreach( $idProdotti as $idProdotto ) {
                $idArticoli = mysqlSelectColumn( 'id', $c, 'SELECT id FROM articoli WHERE id_prodotto = ?', array( array( 's' => $idProdotto ) ) );
                if( ! empty( $idArticoli ) ) {
                    refreshStaticView( $c, 'articoli', $idArticoli );
                    logWrite( "controller finally per $t/$a aggiornata la vista statica per gli articoli del prodotto #" . $idProdotto, 'controller' );
                }
            }

        break;

    }
