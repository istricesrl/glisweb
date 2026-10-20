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
    $needle = "Hello";

    // applicazione della funzione
    $r1 = str_starts_with( $haystack1, $needle );
    $r2 = str_starts_with( $haystack2, $needle );

    // output
    var_dump( $r1 );
    var_dump( $r2 );
