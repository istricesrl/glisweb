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

    // NOTA scontrino di prova a 10,00 € su REP.1 con pagamento in contanti di 20,00 € e calcolo del resto
    // 1000H -> 10,00 € 1R -> REP.1
    // 2000H -> 20,00 € 1T -> totale

    // scrittura di test
	escpos_write( $h, '1000H1R' );
	escpos_write( $h, '2000H1T' );

    // chiusura
	escpos_disconnect( $h );
