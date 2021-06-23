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

    // determino il mime type
    $finfo = finfo_open( FILEINFO_MIME );
    $mimetype = finfo_file( $finfo, DIR_VAR . $_REQUEST['__download__'] );
    finfo_close( $finfo );

    // restituzione contenuto
    header( 'content-type: ' . $mimetype );
    echo file_get_contents( DIR_VAR . $_REQUEST['__download__'] );
