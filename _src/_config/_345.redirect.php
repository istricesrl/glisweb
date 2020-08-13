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
     * @todo finire di documentare
     *
     * @file
     *
     */

    // indicizzazione dei redirect
	if( is_array( $r ) ) {
	    foreach( $r as $redir ) {
		$cf['redirect'][ $redir['sorgente'] ] = $redir;
	    }
	}

    // timer
	timerCheck( $cf['speed'], ' -> fine indicizzazione dei redirect' );

    // URL sorgente al netto della query string
	$source					= strtok( $_SERVER['REQUEST_URI'], '?' );

    // esecuzione
	if( array_key_exists( $source, $cf['redirect'] ) ) {

	    $r = $cf['redirect'][ $source ];

	    logWrite( 'reindirizzamento ' . $r['codice'] . ' da ' . $_SERVER['REQUEST_URI'] . ' a ' . $r['target'], 'redirect' );

	    http_response_code( $r['codice'] );

	    header( 'Location: ' . $r['target'] ); 

	    exit;

	}

    // debug
	// var_dump( strtok( $_SERVER['REQUEST_URI'], '?' ) );

?>
