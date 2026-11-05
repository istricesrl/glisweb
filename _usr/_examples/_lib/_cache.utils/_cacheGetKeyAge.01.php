<?php

    /**
     * file di esempio per la funzione cacheGetKeyAge()
     *
     * legge il timestamp di scrittura, con il motore disco forzato
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // motore disco
    $cf['cache']['engine'] = 'disk';

    // scrittura e eta'
    $t = time();
    cacheWrite( 'TEST_CACHE', 'TEST CONTENT' );
    $age = cacheGetKeyAge( 'TEST_CACHE' );
    var_dump( $age >= $t && $age <= time() );

    // pulizia
    cacheDelete( 'TEST_CACHE' );
