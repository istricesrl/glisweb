<?php

    /**
     * file di esempio per la funzione string2array()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // 
    $a1 = "Hello, world!";
    $a2 = "\x00\x01\x02\x03\x04\x05";

    // applicazione della funzione
    $r1 = isBinaryString( $a1 );
    $r2 = isBinaryString( $a2 );

    // output
    var_dump( $r1 );
    var_dump( $r2 );
