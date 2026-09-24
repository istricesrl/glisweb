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

    // header
    header( 'Content-type: text/plain;' );

    // esempio 01
    echo 'ID indirizzo: ' . inserisciIndirizzo(
        'via Dalla Città 37',
        '40129',
        'Bologna',
        'BO'
    );

    // output
    echo PHP_EOL;
    echo PHP_EOL;

    // esempio 02
    echo 'ID indirizzo: ' . inserisciIndirizzo(
        'largo Ai Giovani 27/b',
        '40100',
        'BOLOGNA',
        'BOLOGNA'
    );

    // output
    echo PHP_EOL;
    echo PHP_EOL;

    // esempio 03
    echo 'ID indirizzo: ' . inserisciIndirizzo(
        'Piazza La Sola 3/4/5',
        '40100',
        'bologna',
        'bologna',
        'borgo panigale'
    );

    // output
    echo PHP_EOL;
    echo PHP_EOL;

    // esempio 04
    echo 'ID indirizzo: ' . inserisciIndirizzo(
        'via alessandro manzoni 18',
        '40100',
        'Bologna',
        'bo',
        'SANTA VIOLA'
    );

    // output
    echo PHP_EOL;
    echo PHP_EOL;

    // esempio 05
    echo 'ID indirizzo: ' . inserisciIndirizzo(
        'viale XVIII ottobre 1976 18/2',
        '40100',
        'Bologna',
        'Bologna'
    );
