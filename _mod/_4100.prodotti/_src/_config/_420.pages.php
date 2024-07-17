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

    // TODO qui ordinare i prodotti per prezzo, dimensione, colore, ecc. secondo i filtri applicati dall'utente

    if( isset( $ct['page']['metadati']['id_prodotto'] )  && ! empty( $ct['page']['metadati']['id_prodotto'] ) ) {

        $ct['page']['contents']['articoli'] = mysqlQuery( $cf['mysql']['connection'],
            'SELECT articoli.id, contenuti.h1, contenuti.cappello, contenuti.specifiche, '
            .'contenuti.title, articoli.id_taglia, articoli.id_colore,  '
            .'lingue_view.ietf FROM articoli '
            .'LEFT JOIN contenuti ON ( contenuti.id_articolo = articoli.id AND contenuti.id_lingua = ? ) '
            .'LEFT JOIN lingue_view ON lingue_view.id = contenuti.id_lingua '
            .'WHERE articoli.id_prodotto = ? '
            .'GROUP BY articoli.id ORDER BY contenuti.h1 ',
            array(
                array( 's' => $cf['localization']['language']['id'] ),
                array( 's' => $ct['page']['metadati']['id_prodotto'] )
            )
        );

        // debug
        // die( print_r( $ct['page']['contents']['articoli'], true ) );

        foreach( $ct['page']['contents']['articoli'] as &$a ) {

            $ct['etc']['selettore']['taglie'][ $a['id_taglia'] ]['articoli'][] = $a['id'];
            $ct['etc']['selettore']['colori'][ $a['id_colore'] ]['articoli'][] = $a['id'];

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

        foreach( $ct['etc']['selettore']['taglie'] as $id_taglia => &$taglia ) {
            $taglia['dettagli'] = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT taglie.* FROM taglie WHERE taglie.id = ? ',
                array( array( 's' => $id_taglia ) )
            );
        }

        foreach( $ct['etc']['selettore']['colori'] as $id_colore => &$colore ) {
            $colore['dettagli'] = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT colori.* FROM colori WHERE colori.id = ? ',
                array( array( 's' => $id_colore ) )
            );
        }

        // die( print_r( $ct['page']['contents']['articoli'], true ) );
        // die( print_r( $ct['etc']['selettore'], true ) );

        $ct['page']['contents']['accessori'] = mysqlQuery( $cf['mysql']['connection'],
            'SELECT prodotti.id, contenuti.h1, contenuti.cappello, contenuti.specifiche, '
            .'contenuti.title, '
            .'lingue_view.ietf FROM prodotti '
            .'INNER JOIN relazioni_prodotti ON relazioni_prodotti.id_prodotto_collegato = prodotti.id '
            .'LEFT JOIN contenuti ON ( contenuti.id_prodotto = prodotti.id AND contenuti.id_lingua = ? ) '
            .'LEFT JOIN lingue_view ON lingue_view.id = contenuti.id_lingua '
            .'WHERE relazioni_prodotti.id_prodotto = ? AND relazioni_prodotti.id_ruolo = 4 '
            .'GROUP BY prodotti.id ORDER BY contenuti.h1 ',
            array(
                array( 's' => $cf['localization']['language']['id'] ),
                array( 's' => $ct['page']['metadati']['id_prodotto'] )
            )
        );

        $ct['page']['contents']['suggeriti'] = mysqlQuery( $cf['mysql']['connection'],
            'SELECT prodotti.id, contenuti.h1, contenuti.cappello, contenuti.specifiche, '
            .'contenuti.title, '
            .'lingue_view.ietf FROM prodotti '
            .'INNER JOIN relazioni_prodotti ON relazioni_prodotti.id_prodotto_collegato = prodotti.id '
            .'LEFT JOIN contenuti ON ( contenuti.id_prodotto = prodotti.id AND contenuti.id_lingua = ? ) '
            .'LEFT JOIN lingue_view ON lingue_view.id = contenuti.id_lingua '
            .'WHERE relazioni_prodotti.id_prodotto = ? AND relazioni_prodotti.id_ruolo = 3 '
            .'GROUP BY prodotti.id ORDER BY contenuti.h1 ',
            array(
                array( 's' => $cf['localization']['language']['id'] ),
                array( 's' => $ct['page']['metadati']['id_prodotto'] )
            )
        );

    }

    // TODO riconciliare questo codice con quello di _src/_inc/_macro/_prodotti.scheda.php

/* aggiungere che se sono in un prodotto devo caricare gli articoli di quel prodotto con tutti i dettagli */ 
