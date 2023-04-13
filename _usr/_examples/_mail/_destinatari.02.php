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
    $testString = 'Fabio Mosti <fabio.mosti@istricesrl.it>, Fabio Videoarts <fabio@videoarts.eu>';

    // inizio output
	$tx	 = 'esempio gestione stringhe mittenti e destinatari' . PHP_EOL;

    // esempio
    $tx .= 'stringa: ' . $testString . PHP_EOL;

    // lavoro
    $ar = mailString2array( $testString );
    $st = array2mailString( $ar );

    // output
    $tx .= print_r( $ar, true );

    // stringa riassemblata
    $tx .= 'stringa: ' . $st . PHP_EOL;

    // output
	build( $tx );
