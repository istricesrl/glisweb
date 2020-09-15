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
     *
     * @todo documentare
     *
     * @file
     *
     */

    // ribalto sulla $_SESSION i dati di $_REQUEST
	if( array_key_exists( '__view__', $_REQUEST ) ) {
	    $_SESSION['__view__'] = array_merge( $_SESSION['__view__'], $_REQUEST['__view__'] );
	}

    // ribalto sulla $_REQUEST i dati di $_SESSION
	$_REQUEST['__view__'] = &$_SESSION['__view__'];

    // timestamp dell'ultima azione sulla sessione
	$_SESSION['used']			= time();

    // debug
	// print_r( $_REQUEST );
	// print_r( $_SESSION );
	// print_r( $cf['contents']['pages']['licenza']['content'] );

?>
