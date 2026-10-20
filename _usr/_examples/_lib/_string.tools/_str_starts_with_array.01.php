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
    $haystack1 = "Hello, world!";
    $haystack2 = "Ciao, mondo!";
    $haystack3 = "Hey, world!";
    $needles = ["Hi", "Hello", "Hey"];

    // applicazione della funzione
    $r1 = str_starts_with_array( $haystack1, $needles );
    $r2 = str_starts_with_array( $haystack2, $needles );
    $r3 = str_starts_with_array( $haystack3, $needles );

    // output
    var_dump( $r1 );
    var_dump( $r2 );
    var_dump( $r3 );
