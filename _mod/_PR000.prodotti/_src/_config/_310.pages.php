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
            logWrite( 'struttura delle categorie prodotti NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR );
        }

	    // recupero le categorie prodotti dal database
		$pgs = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT categorie_prodotti.* FROM categorie_prodotti 
            INNER JOIN pubblicazioni ON pubblicazioni.id_categoria_prodotti = categorie_prodotti.id 
            WHERE categorie_prodotti.id_sito = ? 
            AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) 
            AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) 
            GROUP BY categorie_prodotti.id ',
            array(
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

	    // timer
		timerCheck( $cf['speed'], ' -> fine recupero categorie prodotti dal database' );

        // log
        logger( 'categorie prodotti trovate: ' . print_r( $pgs, true ), 'prodotti' );

        // se ci sono pagine trovate le inserisco nell'array principale
		if( is_array( $pgs ) ) {

		    // ciclo principale
			foreach( $pgs as $pg ) {

                // ID della pagina
                $pid = PREFX_CATEGORIE_PRODOTTI . $pg['id'];
                $pip = PREFX_CATEGORIE_PRODOTTI . $pg['id_genitore'];

                if( ! empty( $pg['id_pagina'] ) ) {
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

                    if( empty( $pg['template'] ) ){ $pg['template'] = $cf['prodotti']['pages']['elenco']['template']; }
                    if( empty( $pg['schema_html'] ) ){ $pg['schema_html'] = $cf['prodotti']['pages']['elenco']['schema']; }
                    if( empty( $pg['tema_css'] ) ){ $pg['tema_css'] = $cf['prodotti']['pages']['elenco']['css']; }

                    // blocco dati principale
                    $cf['contents']['pages'][ $pid ] = array(
                        'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                        'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                        // TODO 'robots'        => $pg['robots'],
                        'parent'		=> array( 'id'		=> $pip ),
                        'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'], 'theme' => $pg['tema_css'] ),
                        'metadati'      => array('id_categoria_prodotti' => $pg['id']),
                        'macro'         => $cf['prodotti']['pages']['elenco']['macro'] ?? []
                    );

                    aggiungiGruppi(
                        $cf['contents']['pages'][$pid],
                        $pg['id']
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_prodotti'
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_prodotti'
                    );

                    aggiungiImmagini(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_prodotti',
                        array(4, 16, 29, 14)
                    );

                    aggiungiMetadati(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_prodotti'
                    );

                    aggiungiMenu(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_prodotti'
                    );

                    // scrivo la pagina in cache
                    memcacheWrite( $cf['memcache']['connection'], 'PAGE_' . $pid, $cf['contents']['pages'][ $pid ] );

                }

            }

        }

	    // timer
		timerCheck( $cf['speed'], ' -> fine elaborazione categorie prodotti prelevate dal database' );

        // recupero le prodotti dal database
		$pgs = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT prodotti.*, prodotti_categorie.id_categoria AS id_categoria, '.
            'pubblicazioni.id_tipologia AS id_tipologia_pubblicazione, tipologie_pubblicazioni.nome AS tipologia_pubblicazione '.
            'FROM prodotti '.
            'INNER JOIN pubblicazioni ON pubblicazioni.id_prodotto = prodotti.id '.
            'INNER JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia '.
            'LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id  '.
            'LEFT JOIN categorie_prodotti ON prodotti_categorie.id_categoria = categorie_prodotti.id '.
            'WHERE categorie_prodotti.id_sito = ? '.
            'AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) '.
            'AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) '.
            'GROUP BY prodotti.id',
            array(
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

	    // timer
		timerCheck( $cf['speed'], ' -> fine recupero prodotti dal database' );

        // log
        logger( 'prodotti trovate: ' . print_r( $pgs, true ), 'prodotti' );

        // se ci sono pagine trovate le inserisco nell'array principale
		if( is_array( $pgs ) ) {

            // ciclo principale
            foreach( $pgs as $pg ) {
            // categorie
            $cat = mysqlQuery( $cf['mysql']['connection'],
                'SELECT prodotti_categorie.id_categoria '
                .'FROM prodotti_categorie '
                .'WHERE prodotti_categorie.id_prodotto = ? '
                .'ORDER BY ordine',
                array( array( 's' => $pg['id'] ) )
            );

            // canonical
            $canon = NULL;

            // creazione della pagina per tutte le prodotti
            foreach( $cat as $ce ) {


                // ID della categoria
                $cid = PREFX_CATEGORIE_PRODOTTI . $ce['id_categoria'];

                // ID della pagina
                $pid = $cid . '.' . PREFX_PRODOTTI . $pg['id'];

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

                    if( empty( $pg['template'] ) ){ $pg['template'] = $cf['prodotti']['pages']['scheda']['template']; }
                    if( empty( $pg['schema_html'] ) ){ $pg['schema_html'] = $cf['prodotti']['pages']['scheda']['schema']; }
                    if( empty( $pg['tema_css'] ) ){ $pg['tema_css'] = $cf['prodotti']['pages']['scheda']['css']; }

                    // blocco dati principale
                    $cf['contents']['pages'][ $pid ] = array(
                        'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                        'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                        // TODO 'robots'        => $pg['robots'],
                        'canonical'		=> $canon,
                        'parent'		=> array( 'id'		=> $cid ),
                        'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'], 'theme' => $pg['tema_css'] ),
                        'metadati'      => array(
                            'id_prodotto' => $pg['id'],
                            'id_tipologia_pubblicazione' => $pg['id_tipologia_pubblicazione'],
                            'tipologia_pubblicazione' => $pg['tipologia_pubblicazione']
                        ),
                        'macro'         => $cf['prodotti']['pages']['scheda']['macro']
                    );

                    aggiungiGruppi(
                        $cf['contents']['pages'][$pid],
                        $pg['id']
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_prodotto'
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_prodotto'
                    );

                    aggiungiImmagini(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_prodotto',
                        array(4, 16, 29, 14)
                    );

                    aggiungiMetadati(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_prodotto'
                    );

                    

/*
                    aggiungiMenu(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_prodotto'
                    );
*/

                    // ...
                    $cf['prodotti']['index'][ $pg['id'] ] = $pid;

                    // canonical
				    $canon = $pid;

                   // scrivo la pagina della prodotto in cache
                    memcacheWrite($cf['memcache']['connection'], 'PAGE_' .  $pid, $cf['contents']['pages'][$pid]);
  
                    }
                }

            }
        }

        // timer
		timerCheck( $cf['speed'], ' -> fine elaborazione prodotti prelevate dal database' );

    } else {
        
	    // recupero la timestamp di aggiornamento più recente
		$cf['contents']['updated'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( categorie_prodotti.timestamp_aggiornamento ) AS updated FROM categorie_prodotti '.
            'INNER JOIN pubblicazioni ON pubblicazioni.id_categoria_prodotti = categorie_prodotti.id '.
            'WHERE categorie_prodotti.id_sito = ? '.
            'AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) '.
            'AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) ',
            array(
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );
        
        // debug
        // echo $cf['contents']['updated'] . PHP_EOL;

    }
