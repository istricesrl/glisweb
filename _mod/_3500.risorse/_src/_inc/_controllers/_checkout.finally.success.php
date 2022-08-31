<?php

    // debug
    // die( print_r( $_SESSION['carrello'] ) );

    // se è presente un ID carrello
    if( isset( $idCarrello ) && ! empty( $idCarrello ) ) {

        // recupero il carrello
        $carrello = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM carrelli WHERE id = ?',
            array(
                array( 's' => $idCarrello )
            )
        );

        // recupero gli articoli
        $articoli = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM carrelli_articoli WHERE id_carrello = ?',
            array(
                array( 's' => $idCarrello )
            )
        );

        // cerco gli articoli che aggiungono crediti
        foreach( $articoli as $articolo ) {

            // recupero la risorsa da collegare
            $risorsa = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT testo FROM metadati WHERE id_articolo = ? AND nome = "risorse|acquisto"',
                array(
                    array( 's' => $articolo['id_articolo'] )
                )
            );

            // se c'è una risorsa da collegare
            if( ! empty( $risorsa ) ) {

                // registro il collegamento
                $movimento = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'id_risorsa' => $risorsa,
                        'id_account' => $carrello['intestazione_id_account'],
                        'note' => 'acquisto risorsa #' . $risorsa . ' con carrello #' . $idCarrello . ' riga #' . $articolo['id'],
                        'timestamp_inserimento' => time()
                    ),
                    'risorse_account'
                );

            }

        }

    }

    // debug
    // die( '<pre>' . print_r( $_SESSION['carrello'], true ) . '<pre>' );
