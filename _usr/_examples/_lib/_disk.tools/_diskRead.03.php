<?php

    /**
     * file di esempio per la funzione diskRead()
     *
     * una chiave che non esiste restituisce false
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // chiave di test
    $k = 'TEST_INESISTENTE';

    // la chiave non c'e'
    diskDelete( $k );
    var_dump( diskRead( $k ) );
