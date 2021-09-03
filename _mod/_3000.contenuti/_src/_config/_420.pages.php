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
	if( isset( $cf['contents']['page']['id'] ) && isset( $cf['localization']['language']['id'] ) ) {

	    // timer
		timerCheck( $cf['speed'], '-> inizio preparazione contenuti specifici per pagina' );

        // prelevo i contenuti della pagina corrente dal database
        $cnt = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT testo AS content, abstract, specifiche, keywords, description FROM contenuti '.
            'WHERE id_pagina = ? AND id_lingua = ?',
            array(
                array( 's' => $cf['contents']['page']['id'] ),
                array( 's' => $cf['localization']['language']['id'] )
            )
        );

        // se sono presenti contenuti
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

            // assegno il meta tag keywords
            if( ! isset( $cf['contents']['page']['keywords'] ) || empty( $cf['contents']['page']['keywords'] ) ) {
                $cf['contents']['page']['keywords'][ $cf['localization']['language']['ietf'] ] = $cnt['keywords'];
            }

            // assegno il meta tag description
            if( ! isset( $cf['contents']['page']['description'] ) || empty( $cf['contents']['page']['description'] ) ) {
                $cf['contents']['page']['description'][ $cf['localization']['language']['ietf'] ] = $cnt['description'];
            }

        }

/*
        // prelevo e assegno le macro
        arrayReplaceRecursive(
            $cf['contents']['page']['macro'],
            mysqlSelectColumn(
                'macro',
                $cf['mysql']['connection'],
                'SELECT macro FROM pagine_macro WHERE id_pagina = ?',
                array(
                    array( 's' => $cf['contents']['page']['id'] )
                )
            )
        );
*/

        // aggiungo le macro
        aggiungiMacro(
            $cf['contents']['page'],
            $cf['contents']['page']['id'],
            'id_pagina'
        );

        // aggiungo le immagini
        aggiungiImmagini(
            $cf['contents']['page'],
            $cf['contents']['page']['id'],
            'id_pagina'
        );

        // timer
        timerCheck( $cf['speed'], '-> fine inserimento immagini' );

        // aggiungo i video
        aggiungiVideo(
            $cf['contents']['page'],
            $cf['contents']['page']['id'],
            'id_pagina'
        );

        // timer
        timerCheck( $cf['speed'], '-> fine inserimento video' );

        // aggiungo i file
        aggiungiFile(
            $cf['contents']['page'],
            $cf['contents']['page']['id'],
            'id_pagina'
        );

        // timer
        timerCheck( $cf['speed'], '-> fine inserimento file' );

/* TODO

        // aggiungo le recensioni
        aggiungiRecensioni(
            $cf['contents']['page'],
            'id_pagina',
            $cf['contents']['page']['id']
        );

        // timer
        timerCheck( $cf['speed'], '-> fine inserimento recensioni' );
*/

        // prelevo i contenuti principali delle sotto pagine dal database
        $subCnt = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT pagine.id,contenuti.cappello,contenuti.abstract '.
            'FROM pagine INNER JOIN contenuti ON contenuti.id_pagina = pagine.id '.
            'WHERE pagine.id_genitore = ? AND id_lingua = ?',
            array(
                array( 's' => $cf['contents']['page']['id'] ),
                array( 's' => $cf['localization']['language']['id'] )
            )
        );

        // se sono presenti contenuti
        if( ! empty( $subCnt ) ) {

            // assegno i sotto contenuti
            foreach( $subCnt as $sc ) {

                // assegno i contenuti
                foreach( array( 'abstract', 'cappello' ) as $k ) {
                    if( empty( $cf['contents']['pages'][ $sc['id'] ][ $k ][ $cf['localization']['language']['ietf'] ] ) ) {
                        $cf['contents']['pages'][ $sc['id'] ][ $k ][ $cf['localization']['language']['ietf'] ] =
                            "{% import '_bin/_default.html' as cms %}\n\n".
                            "{% import 'bin/default.html' as def %}\n\n".
                            $sc[ $k ];
                    }
                }

            }

        }

    }
