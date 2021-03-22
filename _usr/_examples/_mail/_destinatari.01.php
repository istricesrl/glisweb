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

    // stringa per l'esperimento
    $testString = 'Fabio Mosti <fabio.mosti@istricesrl.it>';

    // inizio output
	$tx	 = 'esempio gestione stringhe mittenti e destinatari' . PHP_EOL;

    // esempio
    $tx .= 'stringa: ' . $testString . PHP_EOL;

    // lavoor
    $ar = mailString2array( $testString );

    // output
    $tx .= print_r( $ar, 1 );

    // output
	build( $tx );
