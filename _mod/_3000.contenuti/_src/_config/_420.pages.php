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

    // debug
    ini_set( 'display_errors', 1 );
    ini_set( 'display_startup_errors', 1 );
    error_reporting( E_ALL );

    // verifico se è presente una pagina
	if( isset( $cf['contents']['page']['id'] ) && isset( $cf['localization']['language']['id'] ) ) {

        if( isset( $cf['contents']['page']['metadati']['lp_offerta'] ) ) {

            $joinField = 'id_pagina';
            $joinValue = $cf['contents']['page']['id'];
            $joinTable = 'pagine';
            $subPages = true;

        } elseif( isset( $cf['contents']['page']['metadati']['id_categoria_prodotti'] ) ) {

            $joinField = 'id_categoria_prodotti';
            $joinValue = $cf['contents']['page']['metadati']['id_categoria_prodotti'];
            $joinTable = 'categorie_prodotti';
            $subPages = true;

        } elseif( isset( $cf['contents']['page']['metadati']['id_articolo'] ) ) {

            /**
             * LA PAGINA DI UN ARTICOLO
             *
             * Va PRIMA di quella del prodotto, perche' la pagina di un articolo porta nei metadati
             * tutti e due gli id: senza questo ramo si leggerebbe sempre il contenuto del prodotto,
             * e un articolo con un testo suo non lo mostrerebbe mai.
             *
             * Il ripiego articolo -> prodotto e' qualche riga piu' sotto, dopo la query: qui si
             * sceglie un solo campo di aggancio, e il ripiego ha bisogno di una seconda lettura.
             */
            $joinField = 'id_articolo';
            $joinValue = $cf['contents']['page']['metadati']['id_articolo'];
            $joinTable = 'articoli';
            $subPages = false;

        } elseif( isset( $cf['contents']['page']['metadati']['id_prodotto'] ) ) {

            $joinField = 'id_prodotto';
            $joinValue = $cf['contents']['page']['metadati']['id_prodotto'];
            $joinTable = 'prodotti';
            $subPages = false;

        } elseif( isset( $cf['contents']['page']['metadati']['id_categoria_notizie'] ) ) {

            $joinField = 'id_categoria_notizie';
            $joinValue = $cf['contents']['page']['metadati']['id_categoria_notizie'];
            $joinTable = 'categorie_notizie';
            $subPages = true;

        } elseif( isset( $cf['contents']['page']['metadati']['id_notizia'] ) ) {

            $joinField = 'id_notizia';
            $joinValue = $cf['contents']['page']['metadati']['id_notizia'];
            $joinTable = 'notizie';
            $subPages = false;

        } elseif( isset( $cf['contents']['page']['metadati']['id_categoria_risorse'] ) ) {

            $joinField = 'id_categoria_risorse';
            $joinValue = $cf['contents']['page']['metadati']['id_categoria_risorse'];
            $joinTable = 'categorie_risorse';
            $subPages = true;

        } elseif( isset( $cf['contents']['page']['metadati']['id_risorsa'] ) ) {

            $joinField = 'id_risorsa';
            $joinValue = $cf['contents']['page']['metadati']['id_risorsa'];
            $joinTable = 'risorsa';
            $subPages = false;

        } else {

            $joinField = 'id_pagina';
            $joinValue = $cf['contents']['page']['id'];
            $joinTable = 'pagine';
            $subPages = true;
            
        }

	    // timer
		timerCheck( $cf['speed'], '-> inizio preparazione contenuti specifici per pagina' );

        // prelevo i contenuti della pagina corrente dal database
        $cnt = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT testo AS content, abstract, specifiche, keywords, description, robots FROM contenuti '.
            'WHERE ' . $joinField . ' = ? AND id_lingua = ?',
            array(
                array( 's' => $joinValue ),
                array( 's' => $cf['localization']['language']['id'] )
            )
        );

        /**
         * IL RIPIEGO ARTICOLO -> PRODOTTO
         *
         * Se la pagina e' quella di un articolo che un contenuto suo non ce l'ha, si sale al suo
         * prodotto. E' la regola del modello a tre tipologie, la stessa che _310.pages.php applica
         * a contenuti, immagini e metadati: quello che l'articolo ha se lo tiene, il resto lo
         * prende dal prodotto. Serve alle voci di listino, che una scheda propria non ce l'hanno e
         * descrivono la macchina del loro modello.
         */
        if( empty( $cnt ) && $joinField === 'id_articolo' && ! empty( $cf['contents']['page']['metadati']['id_prodotto'] ) ) {

            $cnt = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT testo AS content, abstract, specifiche, keywords, description, robots FROM contenuti '.
                'WHERE id_prodotto = ? AND id_lingua = ?',
                array(
                    array( 's' => $cf['contents']['page']['metadati']['id_prodotto'] ),
                    array( 's' => $cf['localization']['language']['id'] )
                )
            );

        }

        // die( 'contenuto ' . print_r( $cnt, true ) );

        // se sono presenti contenuti
        if( ! empty( $cnt ) ) {

            // assegno i contenuti
            foreach( array( 'content', 'abstract', 'specifiche' ) as $k ) {
                if( empty( $cf['contents']['page'][ $k ] ) ) {
                    $cf['contents']['page'][ $k ][ $cf['localization']['language']['ietf'] ] =
                        "{% import '_bin/_default.html' as cms %}\n\n".
                        "{% import '_bin/_privacy.html' as prv %}\n\n".
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

            // assegno il meta tag robots
            if( ! isset( $cf['contents']['page']['robots'] ) || empty( $cf['contents']['page']['robots'] ) ) {
                $cf['contents']['page']['robots'][ $cf['localization']['language']['ietf'] ] = $cnt['robots'];
            }

        }

/*
        // prelevo e assegno le macro
        arrayReplaceRecursive(
            $cf['contents']['page']['macro'],
            mysqlSelectColumn(
                'macro',
                $cf['mysql']['connection'],
                'SELECT macro FROM pagine_macro WHERE ' . $joinField . ' = ?',
                array(
                    array( 's' => $cf['contents']['page']['id'] )
                )
            )
        );
*/

        // aggiungo le macro
        // TODO perché è diverso da quelli dopo?
         aggiungiMacro(
            $ct['page'],
            $cf['contents']['page']['id'],
            'id_pagina'
        );

        // aggiungo le immagini
        aggiungiImmagini(
            $cf['contents']['page'],
            $joinValue,
            $joinField
        );

        // timer
        timerCheck( $cf['speed'], '-> fine inserimento immagini' );

        // aggiungo i video
        aggiungiVideo(
            $cf['contents']['page'],
            $joinValue,
            $joinField
        );

        // timer
        timerCheck( $cf['speed'], '-> fine inserimento video' );

        // aggiungo i file
        aggiungiFile(
            $cf['contents']['page'],
            $joinValue,
            $joinField
        );

        // timer
        timerCheck( $cf['speed'], '-> fine inserimento file' );

        // aggiungo le recensioni
        aggiungiRecensioni(
            $cf['contents']['page'],
            $joinValue,
            $joinField,
            $cf['localization']['language']['id']
        );

        // timer
        timerCheck( $cf['speed'], '-> fine inserimento recensioni' );

        // se la tabella è ricorsiva
        if( $subPages == true ) {

            // prelevo i contenuti principali delle sotto pagine dal database
            $subCnt = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT ' . $joinTable . '.id,contenuti.cappello,contenuti.abstract '.
                'FROM ' . $joinTable . ' INNER JOIN contenuti ON contenuti. ' . $joinField . ' = ' . $joinTable . '.id '.
                'WHERE ' . $joinTable . '.id_genitore = ? AND id_lingua = ?',
                array(
                    array( 's' => $joinValue ),
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

    }
