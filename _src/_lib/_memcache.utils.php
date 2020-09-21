<?php

    /**
     * questo file contiene funzioni per l'utilizzo di memcache
     *
     *
     *
     *
     *
     * @file
     *
     */

    /**
     *
     * @todo documentare
     *
     */
    function memcacheCleanFromIndex( $k ) {

	global $cf;

	logWrite( 'richiesta pulizia cache da indice per ' . $k, 'speed' );

	if( isset( $cf['cache']['index'][ $k ] ) && is_array( $cf['cache']['index'][ $k ] ) ) {
	    foreach( $cf['cache']['index'][ $k ] as $t => $l ) {
		logWrite( 'pulizia cache da indice per ' . $k . '/' . $t, 'speed' );
		foreach( $l as $j => $v ) {
		    unset( $cf['cache']['index'][ $k ][ $t ][ $j ] );
		    memcacheDelete( $cf['memcache']['connection'], $j );
		    logWrite( 'pulizia cache da indice per ' . $k . '/' . $t . '/' . $j, 'speed' );
		}
	    }
	}

    }

?>
