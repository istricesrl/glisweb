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
            logWrite( 'struttura delle pagine NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR );
        }

	    // recupero le pagine dal database
		$pgs = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT pagine.* FROM pagine '.
            'INNER JOIN pubblicazioni ON pubblicazioni.id_pagina = pagine.id '.
            'INNER JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia '.
            'WHERE pagine.id_sito = ? '.
            'AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) '.
            'AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) '.
            'AND tipologie_pubblicazioni.se_pubblicato = 1 '.
            'GROUP BY pagine.id ',
            array(
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

	    // timer
		timerCheck( $cf['speed'], '-> fine recupero pagine dal database' );

	    // se ci sono pagine trovate le inserisco nell'array principale
		if( is_array( $pgs ) ) {

		    // ciclo principale
			foreach( $pgs as $pg ) {

			    // aggiornamento delle pagine
				if( $pg['timestamp_aggiornamento'] > $cf['contents']['updated'] ) {
				    $cf['contents']['updated'] = $pg['timestamp_aggiornamento'];
				}

                // prelevo i dati dalla cache
                $age = memcacheGetKeyAge( $cf['memcache']['connection'], 'PAGE_' . $pg['id'] );
                $pgc = memcacheRead( $cf['memcache']['connection'], 'PAGE_' . $pg['id'] );

                // valuto se i dati in cache sono ancora validi
				if( $pg['timestamp_aggiornamento'] > $age || empty( $pgc ) ) {

                    // blocco dati principale
                    $cf['contents']['pages'][ $pg['id'] ] = array(
                        'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                        'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                        'parent'		=> array( 'id'		=> $pg['id_genitore'] ),
                        'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'], 'theme' => $pg['tema_css'] )
                    );

                    // TODO fare aggiungiGruppi()
                    aggiungiGruppi(
                        $cf['contents']['pages'][ $pg['id'] ],
                        $pg['id']
                    );
/*
                    // prelevo i gruppi
                    $groups = mysqlSelectColumn(
                        'nome',
                        $cf['mysql']['connection'],
                        'SELECT gruppi.nome FROM gruppi '.
                        'INNER JOIN pagine_gruppi ON gruppi.id = pagine_gruppi.id_gruppo '.
                        'WHERE pagine_gruppi.id_pagina = ?',
                        array(
                            array( 's' => $pg['id'] )
                        )
                    );				

                    // scrivo i gruppi
                    if( ! empty( $groups ) ) {
                        $cf['contents']['pages'][ $pg['id'] ]['auth']['groups']	= $groups;
                    }
*/

                    // TODO fare aggiungiContenuti()
                    aggiungiContenuti(
                        $cf['contents']['pages'][ $pg['id'] ],
                        $pg['id'],
                        'id_pagina'
                    );
/*
                    // array dei contenuti
                    $cnt = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT contenuti.*, lingue.ietf FROM contenuti '.
                        'INNER JOIN lingue ON lingue.id = contenuti.id_lingua '.
                        'WHERE id_pagina = ?',
                        array(
                            array( 's' => $pg['id'] )
                        )
                    );

                    // ciclo per i contenuti
                    foreach( $cnt as $cn ) {
                        $cf['contents']['pages'][ $pg['id'] ] = array_replace_recursive(
                            $cf['contents']['pages'][ $pg['id'] ],
                            array(
                                'short'             => array( $cn['ietf']	=> $cn['path_custom'] ),
                                'forced'	        => array( $cn['ietf']	=> $cn['url_custom'] ),
                                'custom'	        => array( $cn['ietf']	=> $cn['rewrite_custom'] ),
                                'title'	            => array( $cn['ietf']	=> $cn['title'] ),
                                'h1'	            => array( $cn['ietf']	=> $cn['h1'] ),
                                'h2'	            => array( $cn['ietf']	=> $cn['h2'] ),
                                'h3'	            => array( $cn['ietf']	=> $cn['h3'] ),
                                'og_type'	        => array( $cn['ietf']	=> $cn['og_type'] ),
                                'og_title'	        => array( $cn['ietf']	=> $cn['og_title'] ),
                                'og_image'	        => array( $cn['ietf']	=> $cn['og_image'] ),
                                'og_audio'	        => array( $cn['ietf']	=> $cn['og_audio'] ),
                                'og_video'	        => array( $cn['ietf']	=> $cn['og_video'] ),
                                'og_description'	=> array( $cn['ietf']	=> $cn['og_description'] ),
                                'og_determiner'     => array( $cn['ietf']	=> $cn['og_determiner'] )
                            )
                        );
                    }
*/

                    // aggiungo le immagini
                    aggiungiImmagini(
                        $cf['contents']['pages'][ $pg['id'] ],
                        $pg['id'],
                        'id_pagina',
                        array(1, 3, 4, 5, 7, 8)
                    );

                    // aggiungo i metadati
                    aggiungiMetadati(
                        $cf['contents']['pages'][ $pg['id'] ],
                        $pg['id'],
                        'id_pagina'
                    );

/*
                    // array dei metadati
                    $meta = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT metadati.* FROM metadati '.
                        'WHERE id_pagina = ?',
                        array(
                            array( 's' => $pg['id'] )
                        )
                    );

                    // ciclo per i metadati
                    foreach( $meta as $mta ) {
                        if( empty( $mta['ietf'] ) ) {
                            $cf['contents']['pages'][ $pg['id'] ]['metadati'][ $mta['nome'] ] = $mta['testo'];
                        } else {
                            $cf['contents']['pages'][ $pg['id'] ]['metadati'][ $mta['nome'] ][ $mta['ietf'] ] = $mta['testo'];
                        }
                    }
*/

                    // TODO fare aggiungiMenu()
                    aggiungiMenu(
                        $cf['contents']['pages'][ $pg['id'] ],
                        $pg['id'],
                        'id_pagina'
                    );
/*
                    // array dei menu
                    $mnu = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT menu.*, lingue.ietf FROM menu '.
                        'INNER JOIN lingue ON lingue.id = menu.id_lingua '.
                        'WHERE id_pagina = ?',
                        array(
                            array( 's' => $pg['id'] )
                        )
                    );

                    // ciclo per i menu
                    foreach( $mnu as $mn ) {
                        $cf['contents']['pages'][ $pg['id'] ] = array_replace_recursive(
                            $cf['contents']['pages'][ $pg['id'] ],
                            array(
                                'menu'	=> array( $mn['menu']	=> array(
                                    'label'		=> array( $mn['ietf'] => $mn['nome'] ),
                                    'subpages'	=> $mn['sottopagine'],
                                    'target'	=> ( isset( $mn['target'] ) ) ? $mn['target'] : NULL,
                                    'priority'	=> $mn['ordine'] )
                                )
                            )
                        );
                    }
*/
                    // debug
                    // echo( $pg['id'] . ' cached' . PHP_EOL );

                    // scrivo la pagina in cache
                    memcacheWrite( $cf['memcache']['connection'], 'PAGE_' . $pg['id'], $cf['contents']['pages'][ $pg['id'] ] );

                } else {
                    
                    $cf['contents']['pages'][ $pg['id'] ] = $pgc;

                }

            }

        }

	    // timer
		timerCheck( $cf['speed'], '-> fine elaborazione pagine prelevate dal database' );

    } else {
        
	    // recupero la timestamp di aggiornamento più recente
		$cf['contents']['updated'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( pagine.timestamp_aggiornamento ) AS updated FROM pagine '.
            'INNER JOIN pubblicazioni ON pubblicazioni.id_pagina = pagine.id '.
            'WHERE pagine.id_sito = ? '.
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
