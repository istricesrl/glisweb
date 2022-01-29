<?php

    /**
     * API file standard
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../_config.php';

    // risposta
	$reply = ( isset( $_SESSION['account'] ) ) ? $_SESSION['account'] : array();

    // debug
    // print_r( $_SERVER );
    // print_r( $_SESSION );
    // print_r( $_SESSION['account'] );
    // print_r( apache_request_headers() );

    // output
	buildJson( $reply );
