<?php

    /**
     * file di esempio per la funzione cacheAdd()
     *
     * con il motore disco forzato scrive la chiave solo se non c'e'
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // motore disco
    $cf['cache']['engine'] = 'disk';

    // prima e seconda scrittura
    var_dump( cacheAdd( 'TEST_ADD', 'PRIMO' ) );
    var_dump( cacheAdd( 'TEST_ADD', 'SECONDO' ) );

    // il dato e' il primo
    var_dump( cacheRead( 'TEST_ADD' ) );

    // pulizia
    cacheDelete( 'TEST_ADD' );
