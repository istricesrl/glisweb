<?php

    /**
     * test delle variabili
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../../../_src/_config.php';

    // debug
	ini_set( 'display_errors', 1 );
	ini_set( 'display_startup_errors', 1 );
	error_reporting( E_ALL );

    // ordinamento degli array per la scrittura
	rksort( $cf );

    // output
	$tx	= NULL;
	$tx	.= '<html>';
	$tx	.= '<head></head>';
	$tx	.= '<body style="font-family: monospace;">';

    // array da stampare
	$print = $cf;

    // censuro l'array per evitare fughe accidentali di informazioni sensibili
	array2censored( $print );

    // radice
	$txl = array();
	$txa = array( '<a href="?">$cf</a>' );

    // scendo nell'array
	if( isset( $_REQUEST['lvl'] ) && is_array( $_REQUEST['lvl'] ) ) {
	    foreach( $_REQUEST['lvl'] as $lvl ) {
		$txl['lvl'][] = $lvl;
		$txa[] = '<a href="?' . htmlentities( http_build_query( $txl ) ) . '">' . $lvl . '</a>';
		if( $lvl === 'NULL' ) { $lvl = NULL; }
		if( isset( $print[ $lvl ] ) ) {
#		    print_r( $print );
#		    echo $lvl . ' presente in: ' . print_r( $print, true );
		    $print = $print[ $lvl ];
#		} else {
#		    echo $lvl . ' non presente in: ' . print_r( $print, true );
		}
	    }
	} else {
	    $_REQUEST['lvl'] = array();
	}

    // debug
	// print_r( $print );

    // output
	$tx	.= '<p>' . implode( ' → ', $txa ) . '</p>';
	$tx	.= '<ul>';

    // stampa
	if( empty( $print ) ) {
	    $tx .= '<li>(vuoto)</li>';
	} else {
	    foreach( array_keys( $print ) as $key ) {

		if( ! is_numeric( $key ) && empty( $key ) ) { $keyRef = 'NULL'; } else { $keyRef = $key; }

		$qs['lvl'] = array_merge( $_REQUEST['lvl'], array( $keyRef ) );

		if( isset( $print[ $key ] ) && is_array( $print[ $key ] ) ) {
		    $tx .= '<li><a href="?' . htmlentities( http_build_query( $qs ) ) . '">' . ( ( ! is_numeric( $key ) && empty( $key ) ) ? '(vuoto)' : $key ) . '</a></li>';
		} elseif( isset( $print[ $key ] ) && is_object( $print[ $key ] ) ) {
		    $tx .= '<li>' . str_pad( $key . ' ', 16, '-' ) . ' &#x2192; ' . ( ( ! is_numeric( $key ) && empty( $print[ $key ] ) ) ? '(vuoto)' : print_r( $print[ $key ], true ) ) . '</li>';
		} else {
		    $tx .= '<li>' . str_pad( $key . ' ', 16, '-' ) . ' &#x2192; ' . ( ( ! is_numeric( $key ) && empty( $print[ $key ] ) ) ? '(vuoto)' : $print[ $key ] ) . '</li>';
		}
	    }

	}

    // debug
	// echo '<pre>' . print_r( $_REQUEST, true ) . '</pre>';
	// echo '<pre>' . print_r( $cf, true ) . '</pre>';

    // output
	$tx	.= '</ul>';
	$tx	.= '</body>';
	$tx	.= '</html>';

    // output
	buildHtml( $tx );

?>
