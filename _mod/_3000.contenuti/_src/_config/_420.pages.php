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
		timerCheck( $cf['speed'], ' -> inizio preparazione contenuti specifici per pagina' );

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
                        "{% import '_bin/_contents.html' as cnt %}\n\n".
                        "{% import 'bin/default.html' as def %}\n\n".
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

            // prelevo e assegno le macro
            $cf['contents']['page']['macro'] = mysqlSelectColumn(
                'macro',
                $cf['mysql']['connection'],
                'SELECT macro FROM pagine_macro WHERE id_pagina = ?',
                array(
                    array( 's' => $pg['id'] )
                )
            );

            // aggiungo le immagini
            aggiungiImmagini(
                $cf['contents']['page'],
                'id_pagina',
                $pg['id']
            );

        }

    }
