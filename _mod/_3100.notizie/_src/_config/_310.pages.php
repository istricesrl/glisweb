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
                        'template'		=> array( 'path'	=> $pg['template'], 'schema' => $pg['schema_html'], 'theme' => $pg['tema_css'] )
                    );

                    // TODO

                }

            }

        }

	    // timer
		timerCheck( $cf['speed'], ' -> fine elaborazione categorie notizie prelevate dal database' );

        // recupero le notizie dal database
		$pgs = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT notizie.* FROM notizie '.
            'INNER JOIN pubblicazione ON pubblicazione.id_notizia = notizie.id '.
            'WHERE notizie.id_sito = ? '.
            'AND ( pubblicazione.timestamp_pubblicazione IS NULL OR pubblicazione.timestamp_pubblicazione < ? ) '.
            'AND ( pubblicazione.timestamp_archiviazione IS NULL OR pubblicazione.timestamp_archiviazione > ? ) '.
            'GROUP BY notizie.id ',
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
