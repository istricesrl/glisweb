<?php

    /**
     * file di esempio per la funzione diskAdd()
     *
     * scrive la chiave solo se non c'e': la seconda scrittura non riesce e il dato resta il primo
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // prima e seconda scrittura
    var_dump( diskAdd( 'TEST_ADD', 'PRIMO' ) );
    var_dump( diskAdd( 'TEST_ADD', 'SECONDO' ) );

    // il dato e' il primo
    var_dump( diskRead( 'TEST_ADD' ) );

    // pulizia
    diskDelete( 'TEST_ADD' );
