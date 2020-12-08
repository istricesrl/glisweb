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
            'INNER JOIN pubblicazione ON pubblicazione.id_pagina = pagine.id '.
            'WHERE pagine.id_sito = ? '.
            'AND ( pubblicazione.timestamp_pubblicazione IS NULL OR pubblicazione.timestamp_pubblicazione < ? ) '.
            'AND ( pubblicazione.timestamp_archiviazione IS NULL OR pubblicazione.timestamp_archiviazione > ? ) '.
            'GROUP BY pagine.id ',
            array(
                array( 's' => SITE_CURRENT ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

	    // timer
		timerCheck( $cf['speed'], ' -> fine recupero pagine dal database' );

	    // se ci sono pagine trovate le inserisco nell'array principale
		if( is_array( $pgs ) ) {

		    // ciclo principale
			foreach( $pgs as $pg ) {

			    // aggiornamento delle pagine
				if( $pg['timestamp_aggiornamento'] > $cf['contents']['updated'] ) {
				    $cf['contents']['updated'] = $pg['timestamp_aggiornamento'];
				}

				// blocco dati principale
				$cf['contents']['pages'][ $pg['id'] ] = array(
				    'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
				    'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
				    'parent'		=> array( 'id'		=> $pg['id_genitore'] ),
				    'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'] )
				);

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

            }

        }

    }
