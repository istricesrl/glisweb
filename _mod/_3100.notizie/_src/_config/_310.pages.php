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
            'SELECT categorie_notizie.* FROM categorie_notizie '.
            'INNER JOIN pubblicazione ON pubblicazione.id_categoria_notizie = categorie_notizie.id '.
            'WHERE categorie_notizie.id_sito = ? '.
            'AND ( pubblicazione.timestamp_pubblicazione IS NULL OR pubblicazione.timestamp_pubblicazione < ? ) '.
            'AND ( pubblicazione.timestamp_archiviazione IS NULL OR pubblicazione.timestamp_archiviazione > ? ) '.
            'GROUP BY categorie_notizie.id ',
            array(
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

	    // timer
		timerCheck( $cf['speed'], ' -> fine recupero categorie notizie dal database' );

	    // se ci sono pagine trovate le inserisco nell'array principale
		if( is_array( $pgs ) ) {

		    // ciclo principale
			foreach( $pgs as $pg ) {

                // ID della pagina
                $pid = PREFX_CATEGORIE_NOTIZIE . $pg['id'];
                $pip = PREFX_CATEGORIE_NOTIZIE . $pg['id_genitore'];

			    // aggiornamento delle pagine
				if( $pg['timestamp_aggiornamento'] > $cf['contents']['updated'] ) {
				    $cf['contents']['updated'] = $pg['timestamp_aggiornamento'];
				}

                // prelevo i dati dalla cache
                $age = memcacheGetKeyAge( $cf['memcache']['connection'], $pid );
                $pgc = memcacheRead( $cf['memcache']['connection'], $pid );

                // valuto se i dati in cache sono ancora validi
				if( $pg['timestamp_aggiornamento'] > $age || empty( $pgc ) ) {

                    // blocco dati principale
                    $cf['contents']['pages'][ $pid ] = array(
                        'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                        'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                        'parent'		=> array( 'id'		=> $pip ),
                        'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'], 'theme' => $pg['tema_css'] ),
                        'metadata'      => array('id_categoria_notizie' => $pg['id']),
                        'macro'         => $cf['notizie']['pages']['elenco']['macro']
                    );


                    $cf['contents']['pages'][$pid]['macro'] = array_merge(
                        $cf['contents']['pages'][$pid]['macro'],
                        array('_mod/_3100.notizie/_src/_inc/_macro/_notizie.elenco.php')
                    );


                    aggiungiGruppi(
                        $cf['contents']['pages'][$pid],
                        $pg['id']
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

                }

            }

        }

	    // timer
		timerCheck( $cf['speed'], ' -> fine elaborazione categorie notizie prelevate dal database' );

        // recupero le notizie dal database
		$pgs = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT notizie.*, notizie_categorie.id_categoria AS id_categoria FROM notizie '.
            'INNER JOIN pubblicazione ON pubblicazione.id_notizia = notizie.id '.
            'LEFT JOIN notizie_categorie ON notizie_categorie.id_notizia = notizie.id  '.
            'LEFT JOIN categorie_notizie ON notizie_categorie.id_categoria = categorie_notizie.id '.
            'WHERE categorie_notizie.id_sito = ? '.
            'AND ( pubblicazione.timestamp_pubblicazione IS NULL OR pubblicazione.timestamp_pubblicazione < ? ) '.
            'AND ( pubblicazione.timestamp_archiviazione IS NULL OR pubblicazione.timestamp_archiviazione > ? ) ',
            array(
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

	    // timer
		timerCheck( $cf['speed'], ' -> fine recupero notizie dal database' );

	    // se ci sono pagine trovate le inserisco nell'array principale
		if( is_array( $pgs ) ) {

            // ciclo principale
            foreach( $pgs as $pg ) {

                // ID della categoria
                $cid = PREFX_CATEGORIE_NOTIZIE . $pg['id_categoria'];

                // ID della pagina
                $pid = $cid . '.' . PREFX_NOTIZIE . $pg['id'];

                if (empty($pip)) {
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

                    // blocco dati principale
                    $cf['contents']['pages'][ $pid ] = array(
                        'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                        'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                        'parent'		=> array( 'id'		=> $pip ),
                        'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'], 'theme' => $pg['tema_css'] ),
                        'metadata'      => array('id_notizia' => $pg['id']),
                        'macro'         => $cf['notizie']['pages']['elenco']['macro']
                    );


                    $cf['contents']['pages'][$pid]['macro'] = array_merge(
                        $cf['contents']['pages'][$pid]['macro'],
                        array('_mod/_3100.notizie/_src/_inc/_macro/_notizie.scheda.php')
                    );


                    aggiungiGruppi(
                        $cf['contents']['pages'][$pid],
                        $pg['id']
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

                    aggiungiMenu(
                        $cf['contents']['pages'][$pid],
                        $pg['id'],
                        'id_notizia'
                    );

                    // scrivo la pagina in cache
                    memcacheWrite( $cf['memcache']['connection'], 'PAGE_' . $pg['id'], $cf['contents']['pages'][ $pg['id'] ] );

                }

            }
        }

        	    // timer
		timerCheck( $cf['speed'], ' -> fine elaborazione notizie prelevate dal database' );

    } else {
        
	    // recupero la timestamp di aggiornamento più recente
		$cf['contents']['updated'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( categorie_notizie.timestamp_aggiornamento ) AS updated FROM categorie_notizie '.
            'INNER JOIN pubblicazione ON pubblicazione.id_categoria_notizie = categorie_notizie.id '.
            'WHERE categorie_notizie.id_sito = ? '.
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
