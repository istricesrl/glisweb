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
    $a2 = "Ciao, mondo!";

    // Array di espressioni regolari
    $regexArray = [
        "/^Hello/",  // Verifica se la stringa inizia con "Hello"
        "/world!$/"  // Verifica se la stringa termina con "world!"
    ];

    // applicazione della funzione
    $r1 = inRegexpArray( $a1, $regexArray );
    $r2 = inRegexpArray( $a2, $regexArray );

    // output
    var_dump( $r1 );
    var_dump( $r2 );
