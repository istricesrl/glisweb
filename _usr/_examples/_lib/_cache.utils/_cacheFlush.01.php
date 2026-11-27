<?php

    /**
     * file di esempio per la funzione cacheFlush()
     *
     * svuota il sito corrente in tutti i motori, anche in quelli che la richiesta non usa
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // una chiave su disco e una nell'APCU, se c'e'
    diskWrite( 'TEST_CACHE', 'TEST CONTENT' );
    apcuWrite( 'TEST_CACHE', 'TEST CONTENT' );

    // svuoto
    $esito = cacheFlush();
    var_dump( $esito['disk'] );

    // non c'e' piu' da nessuna parte
    var_dump( diskRead( 'TEST_CACHE' ) );
    var_dump( apcuRead( 'TEST_CACHE' ) );
