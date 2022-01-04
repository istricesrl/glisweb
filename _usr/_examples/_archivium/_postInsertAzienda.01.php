<?php

    /**
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

    // testo della pagina
    $t = null;

    // chiamo la funzione archiviumPostInsertAzienda()
    $s = archiviumPostInsertAzienda( $_REQUEST['id'] );

    // output
    $t .= '<pre>' . var_dump( $s ) . '</pre>';

    // output
    buildHTML( $t );
