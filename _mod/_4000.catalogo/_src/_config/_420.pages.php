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

    // verifico se è presente una pagina
	if( isset( $cf['contents']['page']['metadati']['id_categoria_prodotti'] ) && isset( $cf['localization']['language']['id'] ) ) {

	    // timer
		timerCheck( $cf['speed'], '-> inizio preparazione contenuti specifici per pagina' );

        // prelevo le categorie della pagina corrente dal database
        $cnt = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT testo AS content, abstract, specifiche, keywords, description FROM contenuti '.
            'WHERE id_categoria_prodotti = ? AND id_lingua = ?',
            array(
                array( 's' => $cf['contents']['page']['id'] ),
                array( 's' => $cf['localization']['language']['id'] )
            )
        );

        // se sono presenti categorie
        if( ! empty( $cnt ) ) {

            // assegno i contenuti
            foreach( array( 'content', 'abstract', 'specifiche' ) as $k ) {
                if( empty( $cf['contents']['page'][ $k ] ) ) {
                    $cf['contents']['page'][ $k ][ $cf['localization']['language']['ietf'] ] =
                        "{% import '_bin/_default.html' as cms %}\n\n".
                        "{% import 'bin/default.html' as tpl %}\n\n".
                        $cnt[ $k ];
                }
            }

        }

        // aggiungo le immagini
        aggiungiImmagini(
            $cf['contents']['page'],
            $cf['contents']['page']['id'],
            'id_categoria_prodotti'
        );

        // timer
        timerCheck( $cf['speed'], '-> fine inserimento immagini' );

        // aggiungo i video
        aggiungiVideo(
            $cf['contents']['page'],
            $cf['contents']['page']['id'],
            'id_categoria_prodotti'
        );

        // timer
        timerCheck( $cf['speed'], '-> fine inserimento video' );

        // aggiungo i file
        aggiungiFile(
            $cf['contents']['page'],
            $cf['contents']['page']['id'],
            'id_categoria_prodotti'
        );

        // timer
        timerCheck( $cf['speed'], '-> fine inserimento file' );



    }
