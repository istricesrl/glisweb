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

    if( isset( $ct['page']['metadata']['id_prodotto'] )  && !empty( $ct['page']['metadata']['id_prodotto'] ) ){

        $ct['page']['contents']['articoli'] = mysqlQuery( $cf['mysql']['connection'],
        'SELECT contenuti.id_articolo AS id, contenuti.h1, contenuti.cappello, '
        .'contenuti.title, articoli_view.id_taglia, articoli_view.id_colore,  '
        .'lingue_view.ietf FROM contenuti '
        .'INNER JOIN articoli_view ON articoli_view.id = contenuti.id_articolo '
        .'INNER JOIN lingue_view ON lingue_view.id = contenuti.id_lingua '
        .'WHERE articoli_view.id_prodotto = ? AND contenuti.id_lingua = ? '
        .'GROUP BY articoli_view.id ',
        array(
            array( 's' => $ct['page']['metadata']['id_prodotto'] ),
            array( 's' => $cf['localization']['language']['id'] )
        )
    );

        foreach($ct['page']['contents']['articoli'] as &$a){

            $p = mysqlQuery($cf['mysql']['connection'],
            'SELECT prezzi_view.*, iva.aliquota FROM prezzi_view LEFT JOIN iva ON iva.id = prezzi_view.id_iva  WHERE prezzi_view.id_articolo = ?',
            array( array( 's' => $a['id'] ) )
            );

            foreach($p as $prezzo  ){
                $a['prezzi'][$prezzo['listino'].'/'.$prezzo['valuta'] ] = $prezzo;
            }

            $m = mysqlQuery( $cf['mysql']['connection'],
            'SELECT * fROM metadati WHERE id_articolo = ? AND (id_lingua = ? OR id_lingua IS NULL )',
                array( array( 's' => $a['id'] ) ),
                array( 's' => $cf['localization']['language']['id'] )
            );

            foreach($m as $metadati  ){
                $a['metadati'] = $metadati;
            }
        }

    }   
/* aggiungere che se sono in un prodotto devo caricare gli articoli di quel prodotto con tutti i dettagli */ 