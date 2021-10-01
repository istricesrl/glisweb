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

    // controllo cache
    if( $cf['contents']['cached'] === false ) {

        // log
        if( ! empty( $cf['memcache']['connection'] ) ) {
            logWrite( 'struttura delle categorie catalogo NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR );
        }

	    // recupero le pagine dal database
		$pgs = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT categorie_prodotti.* FROM categorie_prodotti '.
            'INNER JOIN pubblicazione ON pubblicazione.id_categoria_prodotti = categorie_prodotti.id '.
            'WHERE categorie_prodotti.id_sito = ? '.
            'AND ( pubblicazione.timestamp_pubblicazione IS NULL OR pubblicazione.timestamp_pubblicazione < ? ) '.
            'AND ( pubblicazione.timestamp_archiviazione IS NULL OR pubblicazione.timestamp_archiviazione > ? ) '.
            'GROUP BY categorie_prodotti.id ',
            array(
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

	    // timer
		timerCheck( $cf['speed'], ' -> fine recupero categorie catalogo dal database' );

	    // se ci sono pagine trovate le inserisco nell'array principale
		if( is_array( $pgs ) ) {

		    // ciclo principale
			foreach( $pgs as $pg ) {

                // ID della pagina
                $pid = PREFX_CATEGORIE_PRODOTTI . $pg['id'];
                $pip = PREFX_CATEGORIE_PRODOTTI . $pg['id_genitore'];

                if( empty( $pip ) ) {
                    $pip = $pg['id_pagina'];
                }

			    // aggiornamento delle pagine
				if( $pg['timestamp_aggiornamento'] > $cf['contents']['updated'] ) {
				    $cf['contents']['updated'] = $pg['timestamp_aggiornamento'];
				}

                // prelevo i dati dalla cache
                $age = memcacheGetKeyAge( $cf['memcache']['connection'], $pid );
                $pgc = memcacheRead( $cf['memcache']['connection'], $pid );

                // valuto se i dati in cache sono ancora validi
				if( $pg['timestamp_aggiornamento'] > $age || empty( $pgc ) ) {

                    // dati del modulo
                    $cf['catalogo']['categorie'][ $pg['id'] ] = array(
                        'id' => $pg['id'],
                        'parent' => $pg['id_genitore'],
                        'nome' => $pg['nome'],
                        'page' => $id,
                        'tree' => array( $pg['id'] => array() ),
                        'children' => mysqlSelectColumn( 'id', $cf['mysql']['connection'], 'SELECT id FROM categorie_prodotti_view WHERE id_genitore = ? ORDER BY ordine ASC', array( array( 's' => $pg['id'] ) ) ),
                        'url' => NULL
                    );	            

                    // blocco dati principale
                    $cf['contents']['pages'][ $pid ] = array(
                        'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                        'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                        'parent'		=> array( 'id'		=> $pip ),
                        'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'], 'theme' => $pg['tema_css'] ),
                        'metadata'      => array( 'id_categoria_prodotti' => $pg['id'] )
                    );

                    aggiungiGruppi(
                        $cf['contents']['pages'][ $pid ],
                        $pg['id']
                    );
                    
                    aggiungiContenuti(
                        $cf['contents']['pages'][ $pid ],
                        $pg['id'],
                        'id_categoria_prodotti'
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][ $pid ],
                        $pg['id'],
                        'id_categoria_prodotti'
                    );

                    aggiungiImmagini(
                        $cf['contents']['pages'][ $pid ],
                        $pg['id'],
                        'id_categoria_prodotti',
                        array( 4, 16, 29, 14 )
                    );

                    aggiungiMetadati(
                        $cf['contents']['pages'][ $pid ],
                        $pg['id'],
                        'id_categoria_prodotti'
                    );

                    aggiungiMenu(
                        $cf['contents']['pages'][ $pid ],
                        $pg['id'],
                        'id_categoria_prodotti'
                    );

                    // scrivo la pagina in cache
                    memcacheWrite( $cf['memcache']['connection'], 'PAGE_' .  $pid, $cf['contents']['pages'][  $pid ] );

                } else {
                    
                    $cf['contents']['pages'][  $pid ] = $pgc;

                }

            }

        }

	    // timer
		timerCheck( $cf['speed'], ' -> fine elaborazione categorie catalogo prelevate dal database' );

    } else {
        
	    // recupero la timestamp di aggiornamento più recente
		$cf['contents']['updated'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( categorie_prodotti.timestamp_aggiornamento ) AS updated FROM categorie_prodotti '.
            'INNER JOIN pubblicazione ON pubblicazione.id_categoria_prodotti = categorie_prodotti.id '.
            'WHERE categorie_prodotti.id_sito = ? '.
            'AND ( pubblicazione.timestamp_pubblicazione IS NULL OR pubblicazione.timestamp_pubblicazione < ? ) '.
            'AND ( pubblicazione.timestamp_archiviazione IS NULL OR pubblicazione.timestamp_archiviazione > ? ) ',
            array(
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );
        
        // debug
        // echo $cf['contents']['updated'] . PHP_EOL;

    }
