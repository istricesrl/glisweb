<?php

    /**
     * controller pre query per la tabella account
     *
     *
     *
     * @file
     *
     */

    // log
	logWrite( "controller before per ${t}/${a}", 'controller' );

    // controllo azione corrente
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:

		if( empty ( $vs['password']['s'] ) ) {
		    unset( $vs['password'] );
		    removeFromArray( $ks, 'password' );
		}

	    break;

	}

?>
