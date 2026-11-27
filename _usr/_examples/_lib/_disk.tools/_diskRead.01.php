<?php

    /**
     * file di esempio per la funzione diskRead()
     *
     * rilegge il dato scritto con diskWrite(), anche quando e' un array
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // chiave di test
    $k = 'TEST';

    // valore di test
    $v = array( 'TEST CONTENT', 'pagine' => array( 1 => 'TEST' ) );

    // scrivo la chiave
    var_dump( diskWrite( $k, $v ) );

    // rileggo la chiave
    var_dump( diskRead( $k ) === $v );
    var_dump( diskRead( $k ) );
