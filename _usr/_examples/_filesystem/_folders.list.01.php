<?php

    /**
     * test delle cache
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

    // cartella di cui fare la lista
    $f = DIR_MOD;

    // intestazione
    $t = 'elenco sotto cartelle:';

    // lista
    $t .= print_r( getFilteredDirList( $f, '*', true ), true );

    // output
    buildText( $t );
