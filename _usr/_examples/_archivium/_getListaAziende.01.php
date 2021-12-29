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

    // chiamo la funzione archiviumGetListaAziende()
    $list = archiviumGetListaAziende();

    // output
    $t .= '<pre>' . print_r( $list, true ) . '</pre>';

    // output
    buildHTML( $t );
