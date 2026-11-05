<?php

    /**
     * file di esempio per la funzione cacheWrite()
     *
     * scrive con il motore disco forzato: il file sta in var/spool/cache/
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // motore disco
    $cf['cache']['engine'] = 'disk';

    // scrittura
    var_dump( cacheWrite( 'TEST_CACHE', array( 'TEST CONTENT' ) ) );

    // il file c'e'
    $k = 'TEST_CACHE';
    var_dump( is_file( diskKeyPath( diskUniqueKey( $k ) ) ) );

    // pulizia
    cacheDelete( 'TEST_CACHE' );
