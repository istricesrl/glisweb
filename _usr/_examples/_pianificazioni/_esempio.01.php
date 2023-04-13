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

    // output
    $tx = 'esempio pianificazione mensile, una volta al mese per sei mesi' . PHP_EOL . PHP_EOL;

    // parametri
    $start          = date('Y-m-d');                            // data da cui iniziare a creare date
    $periodicita    = 3;                                        // periodicità mensile
    $cadenza        = 1;                                        // ???
    $fine           = date('Y-m-d', strtotime('+6 months') );   // data fino alla quale creare date
    $ripetizioni    = 1;                                        // ???
    $giorni         = array();                                  // giorni della settimana in cui creare date

    // calcolo date
    $date = creazionePianificazione(
        $start,
        $periodicita,
        $cadenza,
        $fine,
        $ripetizioni,
        implode( ',', $giorni )
    );

    // output
    $tx .= print_r( $date, true );

    // output
	build( $tx );
