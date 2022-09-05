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
    $reason = NULL;

    // determino il mime type
    $finfo = finfo_open( FILEINFO_MIME );
    $mimetype = finfo_file( $finfo, DIR_VAR . $_REQUEST['__download__'] );
    finfo_close( $finfo );

    // TODO qui logiche standard di protezione dei file
    if( true ) {
        $authorized = true;
    }

    // controller post checkout
    $cnts = array_merge(
        glob( glob2custom( DIR_MOD_ATTIVI . '_src/_inc/_controllers/_download.before.php' ), GLOB_BRACE ),
        glob( glob2custom( DIR_BASE . '_src/_inc/_macro/_download.before.php', GLOB_BRACE ) )
    );

    // ordinamento delle controller
    sort( $cnts );

    // debug
    // die( print_r( $cnts ) );

    // inclusione delle controller post checkout
    foreach( $cnts as $cnt ) {
        require $cnt;
    }

    // restituzione contenuto
    if( $authorized === true ) {

        header( 'content-type: ' . $mimetype );
        echo file_get_contents( DIR_VAR . $_REQUEST['__download__'] );
    
    } else {

	    http_response_code( 403 );
        header( 'content-type: text/plain' );
        echo 'accesso negato' . ( ( ! empty( $reason ) ) ? ' ('.$reason.')' : NULL );

    }
