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
            logWrite( 'struttura dei prodotti NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR );
        }

	    // recupero le pagine dal database
		$pgs = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT prodotti.* FROM prodotti '.
            'LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id '.
            'LEFT JOIN categorie_prodotti ON categorie_prodotti.id = prodotti_categorie.id_categoria '.
            'INNER JOIN pubblicazione ON pubblicazione.id_prodotto = prodotti.id '.
            'WHERE categorie_prodotti.id_sito = ? '.
            'AND ( pubblicazione.timestamp_pubblicazione IS NULL OR pubblicazione.timestamp_pubblicazione < ? ) '.
            'AND ( pubblicazione.timestamp_archiviazione IS NULL OR pubblicazione.timestamp_archiviazione > ? ) '.
            'GROUP BY prodotti.id ',
            array(
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

	    // timer
		timerCheck( $cf['speed'], ' -> fine recupero prodotti dal database' );

	    // se ci sono pagine trovate le inserisco nell'array principale
		if( is_array( $pgs ) ) {

            // canonical
		    $canon = NULL;

		    // ciclo principale
			foreach( $pgs as $pg ) {

                // ID della pagina
                $pid = PREFX_PRODOTTI . $pg['id'];
                //$pip = PREFX_PRODOTTI . $pg['id_genitore'];

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

                    // blocco dati del modulo
                    $cf['catalogo']['prodotti'][ $pg['id'] ] = array(
                        'id' => $pg['id'],
                        'id_ingombro' => $pg['id_ingombro'],
                        'ingombro_proporzionale' => $pg['ingombro_proporzionale'],
                        'se_disponibile' => $pg['se_disponibile'],
                        'nome' => $pg['nome'],
                        'codice_produttore' => $pg['codice_produttore'],
                        'id_marchio' => $pg['id_marchio'],
                        'page' => NULL,
                        'url' => NULL
                    );
                    
                    // blocco dati principale
                    $cf['contents']['pages'][ $pid ] = array(
                       # 'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                       # 'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                        'parent'		=> array( 'id'		=> $pip ),
                        'canonical'		=> $canon,
                       # 'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'], 'theme' => $pg['tema_css'] ),
                        'metadata'      => array( 'id_prodotto' => $pg['id'] )
                    );

                    aggiungiGruppi(
                        $cf['contents']['pages'][ $pid ],
                        $pg['id']
                    );
                    
                    aggiungiContenuti(
                        $cf['contents']['pages'][ $pid ],
                        $pg['id'],
                        'id_prodotto'
                    );

                    aggiungiContenuti(
                        $cf['contents']['pages'][ $pid ],
                        $pg['id'],
                        'id_prodotto'
                    );

                    aggiungiImmagini(
                        $cf['contents']['pages'][ $pid ],
                        $pg['id'],
                        'id_prodotto',
                        array( 4, 16, 29, 14 )
                    );

                    aggiungiMetadati(
                        $cf['contents']['pages'][ $pid ],
                        $pg['id'],
                        'id_prodotto'
                    );

                    aggiungiMenu(
                        $cf['contents']['pages'][ $pid ],
                        $pg['id'],
                        'id_prodotto'
                    );

                    $cat = mysqlCachedQuery( $cf['memcache']['connection'],
                            $cf['mysql']['connection'],
                            'SELECT categorie_prodotti.*, prodotti_categorie.ordine, contenuti.h1 FROM prodotti_categorie '
                            .'INNER JOIN categorie_prodotti ON categorie_prodotti.id = prodotti_categorie.id_categoria '
                            .'INNER JOIN contenuti ON contenuti.id_categoria_prodotti = categorie_prodotti.id '
                            .'WHERE prodotti_categorie.id_prodotto = ? AND contenuti.id_lingua = ? '
                            .'ORDER BY prodotti_categorie.ordine',
                            array( array( 's' => $pg['id'] ), array( 's' => $cf['localization']['language']['id'] ) ) );
                    
                   // ciclo per le categorie
                    foreach( $cat as $ca ) {
                          $cf['catalogo']['prodotti'][ $pg['id'] ]['categorie'][ sprintf( '%02d', $ca['ordine'] ) ] = $ca;
                    }
                    
                    // array degli articoli 	
                    $articoli = mysqlQuery( $cf['mysql']['connection'],
                                'SELECT contenuti_view.id_articolo AS id, contenuti_view.h1, contenuti_view.cappello, '
                                .'contenuti_view.title, articoli_view.id_taglia, articoli_view.id_colore, articoli_view.se_disponibile, articoli_view.ordine, '
                                .'lingue_view.ietf FROM contenuti_view '
                                .'INNER JOIN articoli_view ON articoli_view.id = contenuti_view.id_articolo '
                                .'INNER JOIN lingue_view ON lingue_view.id = contenuti_view.id_lingua '
                                .'WHERE articoli_view.id_prodotto = ? AND contenuti_view.id_lingua = ? '
                                .'GROUP BY articoli_view.id ',
                                array(
                                    array( 's' => $pg['id'] ),
                                    array( 's' => $cf['localization']['language']['id'] )
                                    )
                                );
                    
                    foreach( $articoli as $art ) {
                            $cf['contents']['pages'][ $pid ]['contents']['articoli'][ $art['id'] ] = $art;
                            }

                    		    // se questa è la pagina canonica...
			if( $canon == NULL ) {

			    // blocco dati del modulo
				$cf['catalogo']['prodotti'][ $pg['id'] ]['page'] = $pid;

			    // collegamento con l'array dei prodotti
			    // NOTA i link simbolici non vengono salvati in memcache
				$cf['catalogo']['prodotti'][ $pg['id'] ]['h1'] = &$cf['contents']['pages'][ $pid ]['h1'];
				$cf['catalogo']['prodotti'][ $pg['id'] ]['h2'] = &$cf['contents']['pages'][ $pid ]['h2'];
				$cf['catalogo']['prodotti'][ $pg['id'] ]['title'] = &$cf['contents']['pages'][ $pid ]['title'];
				$cf['catalogo']['prodotti'][ $pg['id'] ]['cappello'] = &$cf['contents']['pages'][ $pid ]['cappello'];
				$cf['catalogo']['prodotti'][ $pg['id'] ]['url'] = &$cf['contents']['pages'][ $pid ]['url'];
				$cf['catalogo']['prodotti'][ $pg['id'] ]['path'] = &$cf['contents']['pages'][ $pid ]['path'];
				$cf['catalogo']['prodotti'][ $pg['id'] ]['contents'] = &$cf['contents']['pages'][ $pid ]['contents'];

			}

		    // canonical
			$canon = $pid;

                    // scrivo la pagina in cache
                    memcacheWrite( $cf['memcache']['connection'], 'PAGE_' .  $pid, $cf['contents']['pages'][  $pid ] );

                } else {
                    
                    $cf['contents']['pages'][  $pid ] = $pgc;

                }

            }

        }

	    // timer
		timerCheck( $cf['speed'], ' -> fine elaborazione prodotti prelevati dal database' );

    } else {
        
	    // recupero la timestamp di aggiornamento più recente
		$cf['contents']['updated'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( prodotti.timestamp_aggiornamento ) AS updated FROM prodotti '.
            'LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id '.
            'LEFT JOIN categorie_prodotti ON categorie_prodotti.id = prodotti_categorie.id_categoria '.
            'INNER JOIN pubblicazione ON pubblicazione.id_prodotto = prodotti.id '.
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
