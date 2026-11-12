<?php

    /**
     * file di esempio per la funzione apcuAdd()
     *
     * scrive la chiave solo se non c'e': la seconda scrittura non riesce e il dato resta il primo
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // prima e seconda scrittura
    var_dump( apcuAdd( 'TEST_ADD', 'PRIMO' ) );
    var_dump( apcuAdd( 'TEST_ADD', 'SECONDO' ) );

    // il dato e' il primo
    var_dump( apcuRead( 'TEST_ADD' ) );

    // pulizia
    apcuDelete( 'TEST_ADD' );
