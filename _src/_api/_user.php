<?php

    /**
     * API di login/logout
     *
     *
     *
     * TODO documentare
     *
     */

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

    // inclusione del framework
    require '../_config.php';

    // log
    logger( 'login via API', 'details/auth/' . ( isset( $_SESSION['account']['username'] ) ) ? $_SESSION['account']['username'] : 'fail', LOG_ERR );

    // risposta
    $reply = ( isset( $_SESSION['account'] ) ) ? array_diff_key( $_SESSION['account'], array( 'permissions' => '', 'privilegi' => '' ) ) : array( 'err' => 'login errato', 'status' => 'KO' );

    // ...
    $reply['token'] = bin2hex( openssl_random_pseudo_bytes( 16 )) ;

    // ...
    if( isset( $_SESSION['account']['username'] ) ) {

        // ...
        // TODO scrivere questa cosa su Redis impostando un TTL di un'ora
        // writeToFile( $_SESSION['account']['username'], 'etc/secure/tokens/' . $reply['token'] );
        redisWrite( $cf['redis']['connection'], $reply['token'], $_SESSION['account']['username'], 3600 );

    }

    // debug
    // print_r( $_SERVER );
    // print_r( $_SESSION );
    // print_r( $_SESSION['account'] );
    // print_r( apache_request_headers() );

    // output
    buildJson( $reply );
