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
            logWrite( 'struttura delle categorie annunci NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR );
        }

	    // recupero le categorie annunci dal database
		$pgs = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT categorie_annunci.* FROM categorie_annunci '.
            'INNER JOIN pubblicazioni ON pubblicazioni.id_categoria_annunci = categorie_annunci.id '.
            'WHERE categorie_annunci.id_sito = ? '.
            'AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) '.
            'AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) '.
            'GROUP BY categorie_annunci.id ',
            array(
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

	    // timer
		timerCheck( $cf['speed'], ' -> fine recupero categorie annunci dal database' );

	    // se ci sono pagine trovate le inserisco nell'array principale
		if( is_array( $pgs ) ) {

		    // ciclo principale
			foreach( $pgs as $pg ) {

                // ID della pagina
                $pid = PREFX_CATEGORIE_ANNUNCI . $pg['id'];
                $pip = PREFX_CATEGORIE_ANNUNCI . $pg['id_genitore'];

			    // aggiornamento delle pagine
				if( $pg['timestamp_aggiornamento'] > $cf['contents']['updated'] ) {
				    $cf['contents']['updated'] = $pg['timestamp_aggiornamento'];
				}

                // prelevo i dati dalla cache
                $age = memcacheGetKeyAge( $cf['memcache']['connection'], $pid );
                $pgc = memcacheRead( $cf['memcache']['connection'], $pid );

                // valuto se i dati in cache sono ancora validi
				if( $pg['timestamp_aggiornamento'] > $age || empty( $pgc ) ) {

                    if( empty( $pg['template'] ) ){ $pg['template'] = $cf['annunci']['pages']['elenco']['template']; }
                    if( empty( $pg['schema_html'] ) ){ $pg['schema_html'] = $cf['annunci']['pages']['elenco']['schema']; }
                    if( empty( $pg['tema_css'] ) ){ $pg['tema_css'] = $cf['annunci']['pages']['elenco']['css']; }

                    // blocco dati principale
                    $cf['contents']['pages'][ $pid ] = array(
                        'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                        'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                        // TODO 'robots'        => $pg['robots'],
                        'parent'		=> array( 'id'		=> $pip ),
                        'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'], 'theme' => $pg['tema_css'] ),
                        'metadati'      => array('id_categoria_annunci' => $pg['id']),
                        'macro'         => $cf['annunci']['pages']['elenco']['macro']
                    );

                    aggiungiGruppi(
                        $cf['contents']['pages'][$pid],
                        $pg['id']
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_annunci'
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_annunci'
                    );

                    aggiungiImmagini(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_annunci',
                        array(4, 16, 29, 14)
                    );

                    aggiungiMetadati(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_annunci'
                    );

                    aggiungiMenu(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_annunci'
                    );

                    // scrivo la pagina in cache
                    memcacheWrite( $cf['memcache']['connection'], 'PAGE_' . $pid, $cf['contents']['pages'][ $pid ] );

                }

            }

        }

	    // timer
		timerCheck( $cf['speed'], ' -> fine elaborazione categorie annunci prelevate dal database' );

        // recupero le annunci dal database
		$pgs = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT annunci.*, annunci_categorie.id_categoria AS id_categoria, '.
            'pubblicazioni.id_tipologia AS id_tipologia_pubblicazione, tipologie_pubblicazioni.nome AS tipologia_pubblicazione '.
            'FROM annunci '.
            'INNER JOIN pubblicazioni ON pubblicazioni.id_annuncio = annunci.id '.
            'INNER JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia '.
            'LEFT JOIN annunci_categorie ON annunci_categorie.id_annuncio = annunci.id  '.
            'LEFT JOIN categorie_annunci ON annunci_categorie.id_categoria = categorie_annunci.id '.
            'WHERE categorie_annunci.id_sito = ? '.
            'AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) '.
            'AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) '.
            'GROUP BY annunci.id',
            array(
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

	    // timer
		timerCheck( $cf['speed'], ' -> fine recupero annunci dal database' );

	    // se ci sono pagine trovate le inserisco nell'array principale
		if( is_array( $pgs ) ) {

            // ciclo principale
            foreach( $pgs as $pg ) {
            // categorie
            $cat = mysqlQuery( $cf['mysql']['connection'],
                'SELECT annunci_categorie.id_categoria '
                .'FROM annunci_categorie '
                .'WHERE annunci_categorie.id_annuncio = ? '
                .'ORDER BY ordine',
                array( array( 's' => $pg['id'] ) )
            );

            // canonical
            $canon = NULL;

            // creazione della pagina per tutte le annunci
            foreach( $cat as $ce ) {


                // ID della categoria
                $cid = PREFX_CATEGORIE_ANNUNCI . $ce['id_categoria'];

                // ID della pagina
                $pid = $cid . '.' . PREFX_ANNUNCI . $pg['id'];

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

                    if( empty( $pg['template'] ) ){ $pg['template'] = $cf['annunci']['pages']['scheda']['template']; }
                    if( empty( $pg['schema_html'] ) ){ $pg['schema_html'] = $cf['annunci']['pages']['scheda']['schema']; }
                    if( empty( $pg['tema_css'] ) ){ $pg['tema_css'] = $cf['annunci']['pages']['scheda']['css']; }

                    // blocco dati principale
                    $cf['contents']['pages'][ $pid ] = array(
                        'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                        'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                        // TODO 'robots'        => $pg['robots'],
                        'canonical'		=> $canon,
                        'parent'		=> array( 'id'		=> $cid ),
                        'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'], 'theme' => $pg['tema_css'] ),
                        'metadati'      => array(
                            'id_annuncio' => $pg['id'],
                            'id_tipologia_pubblicazione' => $pg['id_tipologia_pubblicazione'],
                            'tipologia_pubblicazione' => $pg['tipologia_pubblicazione']
                        ),
                        'macro'         => $cf['annunci']['pages']['scheda']['macro']
                    );

                    aggiungiGruppi(
                        $cf['contents']['pages'][$pid],
                        $pg['id']
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_annuncio'
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_annuncio'
                    );

                    aggiungiImmagini(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_annuncio',
                        array(4, 16, 29, 14)
                    );

                    aggiungiMetadati(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_annuncio'
                    );
/*
                    aggiungiMenu(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_annuncio'
                    );
*/
                    // canonical
				    $canon = $pid;

                   // scrivo la pagina della annuncio in cache
                    memcacheWrite($cf['memcache']['connection'], 'PAGE_' .  $pid, $cf['contents']['pages'][$pid]);
  
                    }
                }

            }
        }

        // timer
		timerCheck( $cf['speed'], ' -> fine elaborazione annunci prelevate dal database' );

    } else {
        
	    // recupero la timestamp di aggiornamento più recente
		$cf['contents']['updated'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( categorie_annunci.timestamp_aggiornamento ) AS updated FROM categorie_annunci '.
            'INNER JOIN pubblicazioni ON pubblicazioni.id_categoria_annunci = categorie_annunci.id '.
            'WHERE categorie_annunci.id_sito = ? '.
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
