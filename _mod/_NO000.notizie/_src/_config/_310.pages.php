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
            logWrite( 'struttura delle categorie notizie NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR );
        }

	    // recupero le categorie notizie dal database
		$pgs = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT ( SELECT max( greatest( coalesce( pp.timestamp_aggiornamento, 0 ), if( pp.timestamp_inizio < ?, pp.timestamp_inizio, 0 ), if( pp.timestamp_fine < ?, pp.timestamp_fine, 0 ) ) ) FROM pubblicazioni AS pp WHERE pp.id_categoria_notizie = categorie_notizie.id ) AS timestamp_pubblicazione, categorie_notizie.* FROM categorie_notizie 
            INNER JOIN pubblicazioni ON pubblicazioni.id_categoria_notizie = categorie_notizie.id 
            WHERE categorie_notizie.id_sito = ? 
            AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) 
            AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) 
            GROUP BY categorie_notizie.id ',
            array(
                array( 's' => time() ),
                array( 's' => time() ),
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

	    // timer
		timerCheck( $cf['speed'], ' -> fine recupero categorie notizie dal database' );

        // log
        logger( 'categorie notizie trovate: ' . print_r( $pgs, true ), 'notizie' );

        // se ci sono pagine trovate le inserisco nell'array principale
		if( is_array( $pgs ) ) {

		    // ciclo principale
			foreach( $pgs as $pg ) {

                // le modifiche alle pubblicazioni e le finestre che si aprono valgono come aggiornamenti della pagina
                $pg['timestamp_aggiornamento'] = max( $pg['timestamp_aggiornamento'], $pg['timestamp_pubblicazione'] );

                // ID della pagina
                $pid = PREFX_CATEGORIE_NOTIZIE . $pg['id'];
                $pip = PREFX_CATEGORIE_NOTIZIE . $pg['id_genitore'];

                if( ! empty( $pg['id_pagina'] ) ) {
                    $pip = $pg['id_pagina'];
                }

                // aggiornamento delle pagine
				if( $pg['timestamp_aggiornamento'] > $cf['contents']['updated'] ) {
				    $cf['contents']['updated'] = $pg['timestamp_aggiornamento'];
				}

                // prelevo i dati dalla cache
                $age = memcacheGetKeyAge( $cf['memcache']['connection'], 'PAGE_' . $pid );
                $pgc = memcacheRead( $cf['memcache']['connection'], 'PAGE_' . $pid );

                // valuto se i dati in cache sono ancora validi
				if( $pg['timestamp_aggiornamento'] > $age || empty( $pgc ) ) {

                    if( empty( $pg['template'] ) ){ $pg['template'] = $cf['notizie']['pages']['elenco']['template']; }
                    if( empty( $pg['schema_html'] ) ){ $pg['schema_html'] = $cf['notizie']['pages']['elenco']['schema']; }
                    if( empty( $pg['tema_css'] ) ){ $pg['tema_css'] = $cf['notizie']['pages']['elenco']['css']; }

                    // blocco dati principale
                    $cf['contents']['pages'][ $pid ] = array(
                        'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                        'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                        // TODO 'robots'        => $pg['robots'],
                        'parent'		=> array( 'id'		=> $pip ),
                        'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'], 'theme' => $pg['tema_css'] ),
                        'metadati'      => array('id_categoria_notizie' => $pg['id']),
                        'macro'         => $cf['notizie']['pages']['elenco']['macro'] ?? []
                    );

                    aggiungiGruppi(
                        $cf['contents']['pages'][$pid],
                        $pg['id']
                    );

                    // se è soltanto in anteprima la pagina è riservata al gruppo anteprima
                    aggiungiPubblicazione(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_notizie'
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_notizie'
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_notizie'
                    );

                    aggiungiImmagini(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_notizie',
                        array(4, 16, 29, 14)
                    );

                    aggiungiMetadati(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_notizie'
                    );

                    aggiungiMenu(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_categoria_notizie'
                    );

                    // scrivo la pagina in cache
                    memcacheWrite( $cf['memcache']['connection'], 'PAGE_' . $pid, $cf['contents']['pages'][ $pid ] );

                } else {

                    $cf['contents']['pages'][ $pid ] = $pgc;

                }

            }

        }

	    // timer
		timerCheck( $cf['speed'], ' -> fine elaborazione categorie notizie prelevate dal database' );

        // recupero le notizie dal database
		$pgs = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT ( SELECT max( greatest( coalesce( pp.timestamp_aggiornamento, 0 ), if( pp.timestamp_inizio < ?, pp.timestamp_inizio, 0 ), if( pp.timestamp_fine < ?, pp.timestamp_fine, 0 ) ) ) FROM pubblicazioni AS pp WHERE pp.id_notizia = notizie.id ) AS timestamp_pubblicazione, notizie.*, notizie_categorie.id_categoria AS id_categoria, '.
            'pubblicazioni.id_tipologia AS id_tipologia_pubblicazione, tipologie_pubblicazioni.nome AS tipologia_pubblicazione '.
            'FROM notizie '.
            'INNER JOIN pubblicazioni ON pubblicazioni.id_notizia = notizie.id '.
            'INNER JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia '.
            'LEFT JOIN notizie_categorie ON notizie_categorie.id_notizia = notizie.id  '.
            'LEFT JOIN categorie_notizie ON notizie_categorie.id_categoria = categorie_notizie.id '.
            'WHERE categorie_notizie.id_sito = ? '.
            'AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) '.
            'AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) '.
            'GROUP BY notizie.id',
            array(
                array( 's' => time() ),
                array( 's' => time() ),
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

	    // timer
		timerCheck( $cf['speed'], ' -> fine recupero notizie dal database' );

        // log
        logger( 'notizie trovate: ' . print_r( $pgs, true ), 'notizie' );

        // se ci sono pagine trovate le inserisco nell'array principale
		if( is_array( $pgs ) ) {

            // ciclo principale
            foreach( $pgs as $pg ) {

            // le modifiche alle pubblicazioni e le finestre che si aprono valgono come aggiornamenti della pagina
            $pg['timestamp_aggiornamento'] = max( $pg['timestamp_aggiornamento'], $pg['timestamp_pubblicazione'] );
            // categorie
            $cat = mysqlQuery( $cf['mysql']['connection'],
                'SELECT notizie_categorie.id_categoria '
                .'FROM notizie_categorie '
                .'WHERE notizie_categorie.id_notizia = ? '
                .'ORDER BY ordine',
                array( array( 's' => $pg['id'] ) )
            );

            // canonical
            $canon = NULL;

            // creazione della pagina per tutte le notizie
            foreach( $cat as $ce ) {


                // ID della categoria
                $cid = PREFX_CATEGORIE_NOTIZIE . $ce['id_categoria'];

                // ID della pagina
                $pid = $cid . '.' . PREFX_NOTIZIE . $pg['id'];

                if( empty( $pip ) ) {
                    $pip = $pg['id_pagina'];
                }

			    // aggiornamento delle pagine
				if( $pg['timestamp_aggiornamento'] > $cf['contents']['updated'] ) {
				    $cf['contents']['updated'] = $pg['timestamp_aggiornamento'];
				}

                // prelevo i dati dalla cache
                $age = memcacheGetKeyAge( $cf['memcache']['connection'], 'PAGE_' . $pid );
                $pgc = memcacheRead( $cf['memcache']['connection'], 'PAGE_' . $pid );

                // valuto se i dati in cache sono ancora validi
				if( $pg['timestamp_aggiornamento'] > $age || empty( $pgc ) ) {

                    if( empty( $pg['template'] ) ){ $pg['template'] = $cf['notizie']['pages']['scheda']['template']; }
                    if( empty( $pg['schema_html'] ) ){ $pg['schema_html'] = $cf['notizie']['pages']['scheda']['schema']; }
                    if( empty( $pg['tema_css'] ) ){ $pg['tema_css'] = $cf['notizie']['pages']['scheda']['css']; }

                    // blocco dati principale
                    $cf['contents']['pages'][ $pid ] = array(
                        'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                        'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                        // TODO 'robots'        => $pg['robots'],
                        'canonical'		=> $canon,
                        'parent'		=> array( 'id'		=> $cid ),
                        'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'], 'theme' => $pg['tema_css'] ),
                        'metadati'      => array(
                            'id_notizia' => $pg['id'],
                            'id_tipologia_pubblicazione' => $pg['id_tipologia_pubblicazione'],
                            'tipologia_pubblicazione' => $pg['tipologia_pubblicazione']
                        ),
                        'macro'         => $cf['notizie']['pages']['scheda']['macro']
                    );

                    aggiungiGruppi(
                        $cf['contents']['pages'][$pid],
                        $pg['id']
                    );

                    // se è soltanto in anteprima la pagina è riservata al gruppo anteprima
                    aggiungiPubblicazione(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_notizia'
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_notizia'
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_notizia'
                    );

                    aggiungiImmagini(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_notizia',
                        array(4, 16, 29, 14)
                    );

                    aggiungiMetadati(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_notizia'
                    );

                    

/*
                    aggiungiMenu(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_notizia'
                    );
*/

                    // ...
                    $cf['notizie']['index'][ $pg['id'] ] = $pid;

                    // canonical
				    $canon = $pid;

                   // scrivo la pagina della notizia in cache
                    memcacheWrite($cf['memcache']['connection'], 'PAGE_' .  $pid, $cf['contents']['pages'][$pid]);

                    } else {

                    $cf['contents']['pages'][ $pid ] = $pgc;

                    // ...
                    $cf['notizie']['index'][ $pg['id'] ] = $pid;

                    // canonical
                    $canon = $pid;

                    }
                }

            }
        }

        // timer
		timerCheck( $cf['speed'], ' -> fine elaborazione notizie prelevate dal database' );

    } else {
        
	    // recupero la timestamp di aggiornamento più recente
		$cf['contents']['updated'] = max(
		    $cf['contents']['updated'],
		    mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT max( greatest( coalesce( categorie_notizie.timestamp_aggiornamento, 0 ), coalesce( pubblicazioni.timestamp_aggiornamento, 0 ), if( pubblicazioni.timestamp_inizio < ?, pubblicazioni.timestamp_inizio, 0 ), if( pubblicazioni.timestamp_fine < ?, pubblicazioni.timestamp_fine, 0 ) ) ) AS updated FROM categorie_notizie '.
                'INNER JOIN pubblicazioni ON pubblicazioni.id_categoria_notizie = categorie_notizie.id '.
                'WHERE categorie_notizie.id_sito = ? ',
                array(
                    array( 's' => time() ),
                    array( 's' => time() ),
                    array( 's' => SITE_CURRENT )
                )
            )
		);
        
        // debug
        // echo $cf['contents']['updated'] . PHP_EOL;

    }
