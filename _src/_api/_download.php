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

    // debug
    // print_r( $_REQUEST );

    // variabile generale per il comportamento
    $authorized = false;

    // determino il mime type
    $finfo = finfo_open( FILEINFO_MIME );
    $mimetype = finfo_file( $finfo, DIR_VAR . $_REQUEST['__download__'] );
    finfo_close( $finfo );

    // TODO qui logiche standard di protezione dei file
    if( true ) {
        $authorized = true;
    }

    // logiche custom di protezione dei file
    if( file_exists( DIR_BASE . 'src/inc/macro/download.finally.php' ) ) {
        require DIR_BASE . 'src/inc/macro/download.finally.php';
    }

    // restituzione contenuto
    if( $authorized === true ) {

        header( 'content-type: ' . $mimetype );
        echo file_get_contents( DIR_VAR . $_REQUEST['__download__'] );
    
    } else {

	    http_response_code( 403 );
        header( 'content-type: text/plain' );
        echo 'accesso negato';

    }
