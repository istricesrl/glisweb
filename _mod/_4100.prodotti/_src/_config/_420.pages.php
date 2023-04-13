<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // print_r( $ct['page']['contents'] );

    if( isset( $ct['page']['metadati']['id_prodotto'] )  && ! empty( $ct['page']['metadati']['id_prodotto'] ) ) {

        $ct['page']['contents']['articoli'] = mysqlQuery( $cf['mysql']['connection'],
            'SELECT articoli.id, contenuti.h1, contenuti.cappello, contenuti.specifiche, '
            .'contenuti.title, articoli.id_taglia, articoli.id_colore,  '
            .'lingue_view.ietf FROM articoli '
            .'LEFT JOIN contenuti ON ( contenuti.id_articolo = articoli.id AND contenuti.id_lingua = ? ) '
            .'LEFT JOIN lingue_view ON lingue_view.id = contenuti.id_lingua '
            .'WHERE articoli.id_prodotto = ? '
            .'GROUP BY articoli.id ',
            array(
                array( 's' => $cf['localization']['language']['id'] ),
                array( 's' => $ct['page']['metadati']['id_prodotto'] )
            )
        );

        // print_r( $ct['page']['contents']['articoli'] );

        foreach( $ct['page']['contents']['articoli'] as &$a ) {

            $p = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT prezzi_view.*, iva.aliquota, '
                .'( prezzi_view.prezzo * ( ( iva.aliquota + 100 ) / 100 ) ) AS prezzo_lordo '
                .'FROM prezzi_view '
                .'LEFT JOIN iva ON iva.id = prezzi_view.id_iva '
                .'WHERE prezzi_view.id_articolo = ? ',
                array( array( 's' => $a['id'] ) )
            );

            foreach( $p as $prezzo ) {
                $a['prezzi'][ $prezzo['listino'] ] = $prezzo;
            }

            aggiungiMetadati(
                $a,
                $a['id'],
                'id_articolo'
            );

        }

        // die( print_r( $ct['page']['contents']['articoli'], true ) );

    }

    // TODO riconciliare questo codice con quello di _src/_inc/_macro/_prodotti.scheda.php

/* aggiungere che se sono in un prodotto devo caricare gli articoli di quel prodotto con tutti i dettagli */ 
