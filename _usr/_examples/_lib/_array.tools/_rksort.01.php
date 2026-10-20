<?php

    /**
     * file di esempio per la funzione string2array()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // dati di test
    $s = array( 'key3' => 'val3', 'key1' => 'val1', 'key2' => array( 'key5' => 'val5', 'key4' => 'val4' ) );

    // ...
    rksort( $s );

    // ...
    $t1 = implode( array_keys( $s ) );
    $t2 = implode( array_keys( $s['key2'] ) );

    // output
    var_dump( $t1 );
    var_dump( $t2 );
