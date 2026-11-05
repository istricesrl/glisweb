<?php

    /**
     * file di esempio per la funzione diskGetKeyAge()
     *
     * legge il momento della scrittura di una chiave
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // chiave di test
    $k = 'TEST';

    // valore di test
    $v = 'TEST CONTENT';

    // scrivo la chiave
    var_dump( diskWrite( $k, $v ) );

    // l'eta' e' il timestamp della scrittura
    var_dump( diskGetKeyAge( $k ) );
    var_dump( abs( diskGetKeyAge( $k ) - time() ) < 5 );
