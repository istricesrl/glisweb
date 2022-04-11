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
    $l = archiviumGetListaFePassive( $_REQUEST['idAzienda'] );

    // output
    $t .= '<pre>' . htmlspecialchars( print_r( $l, true ) ) . '</pre>';

    // output
    buildHTML( $t );
