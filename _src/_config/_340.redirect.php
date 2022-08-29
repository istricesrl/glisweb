<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     * @todo $cf['redirect'] dovrebbe stare in cache, visto che elaborarlo può essere oneroso se i redirect sono tanti
     * @todo finire di documentare
     *
     * @file
     *
     */

    // inizializzazione array redirect
	$cf['redirect'] = $r = array();

    // redirect da CSV
	if( file_exists( FILE_REDIRECT ) ) {
/*
	    $r = readFromFile( FILE_REDIRECT );

	    foreach( $r as $riga ) {
		$valori = explode( '|', $riga );
		$cf['redirect'][ $valori[0] ][ $valori[1] ] = $valori[2];
	    }
*/
	    $r = csvFile2array( FILE_REDIRECT );

	}

    // redirect da CMS
	if( ! empty( $cf['mysql']['connection'] ) ) {
	    $r = array_merge(
			$r,
			mysqlQuery(
				$cf['mysql']['connection'],
				'SELECT id,codice,sorgente,destinazione FROM redirect_view'
			)
	    );
	}

    // configurazione extra
	if( isset( $cx['redirect'] ) ) {
	    $r = array_replace_recursive(
			$r,
			$cx['redirect']
	    );
	}

    // NOTA esempio di riga del file redirect.csv
    // codice,sorgente,destinazione
    // 301,/vecchia/pagina.html,http://host.domain.bogus/nuova/pagina.html

    // debug
	// print_r( $r );
	// die( 'cx -> ' . print_r( $cx, true ) );
	// print_r( $cx['redirect'] );
	// var_dump( strtok( $_SERVER['REQUEST_URI'], '?' ) );
	// var_dump( mysqlQuery( $cf['mysql']['connection'], 'SELECT codice,sorgente,destinazione FROM redirect_view' ) );
