<?php

    /**
     * API di login/logout
     *
     *
     *
     * TODO documentare
     * TODO proteggere da brute force
     *
     */

    // ...
    define( 'LOGIN_VIA_API', true );

    // ...
    $json = file_get_contents( 'php://input' );

    // ...
    $data = json_decode( $json, true );

    // ...
    if( is_array( $data ) ) {
        $_REQUEST = array_replace_recursive(
            $_REQUEST,
            $data
        );
    }

    // ...
    // die( $json );
    // die( print_r( $_REQUEST, true ) );

    // inclusione del framework
    if( ! defined( 'INCLUDE_SUBDIR' ) ) {
        require '../_config.php';
    } else {
        require INCLUDE_SUBDIR . '_config.php';
    }

    // ...
    if( isset( $_SESSION['account']['username'] ) ) {

        // log
        logger( 'login via API', 'details/auth/' . $_SESSION['account']['username'], LOG_ERR );

        // risposta
        $reply = ( isset( $_SESSION['account'] ) ) ? array_diff_key( $_SESSION['account'], array( 'permissions' => '', 'privilegi' => '', 'password' => '' ) ) : array( 'err' => 'login errato', 'status' => 'KO' );

        // ...
        $reply['token'] = bin2hex( openssl_random_pseudo_bytes( 16 )) ;

        // ...
        // TODO scrivere questa cosa su Redis impostando un TTL di un'ora
        // writeToFile( $_SESSION['account']['username'], 'etc/secure/tokens/' . $reply['token'] );
        redisWrite( $cf['redis']['connection'], $reply['token'], $_SESSION['account']['username'], 3600 );

    } else {

        // risposta
        $reply = array( 'err' => 'login errato', 'status' => 'KO' );

    }

    // debug
    // print_r( $_SERVER );
    // print_r( $_SESSION );
    // print_r( $_SESSION['account'] );
    // print_r( apache_request_headers() );

    // output
    buildJson( $reply );
