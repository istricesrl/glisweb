<?php

    /**
     * file di esempio per la funzione cacheRead()
     *
     * con il motore apcu una chiave che non sta nell'APCU si cerca su disco
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // il motore apcu c'e'?
    $cf['cache']['engine'] = 'apcu';
    if( cacheEngine() !== 'apcu' ) {
        die( 'APCU non disponibile' );
    }

    // una chiave solo su disco
    apcuDelete( 'TEST_CACHE' );
    diskWrite( 'TEST_CACHE', 'TEST CONTENT DISCO' );
    var_dump( cacheRead( 'TEST_CACHE' ) );

    // la scrittura nell'APCU toglie la copia su disco
    var_dump( cacheWrite( 'TEST_CACHE', 'TEST CONTENT APCU' ) );
    var_dump( diskRead( 'TEST_CACHE' ) );

    // pulizia
    cacheDelete( 'TEST_CACHE' );
