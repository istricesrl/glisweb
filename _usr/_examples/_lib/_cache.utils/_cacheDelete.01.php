<?php

    /**
     * file di esempio per la funzione cacheDelete()
     *
     * cancella la chiave, con il motore disco forzato
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // motore disco
    $cf['cache']['engine'] = 'disk';

    // scrittura e cancellazione
    var_dump( cacheWrite( 'TEST_CACHE', 'TEST CONTENT' ) );
    var_dump( cacheDelete( 'TEST_CACHE' ) );
    var_dump( cacheRead( 'TEST_CACHE' ) );
