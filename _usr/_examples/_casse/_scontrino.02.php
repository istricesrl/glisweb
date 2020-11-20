<?php

    /**
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // debug
	// print_r( $_REQUEST );
	// print_r( $_GET );
	// die();

    // inclusione del framework
	require '../../../_src/_config.php';

    // connessione
	$h = escpos_connect( '192.168.1.137' );

    // NOTA scontrino di prova a 0,01 € su REP.1
    // 1H -> 0,01 € 1R -> REP.1
    // 1T -> totale

    // scrittura di test
	escpos_write( $h, '1H1R' );
	escpos_write( $h, '1T' );

    // chiusura
	escpos_disconnect( $h );
