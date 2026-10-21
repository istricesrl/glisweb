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
    $a1 = True;
    $a2 = False;

    // applicazione della funzione
    $r1 = boolean2string( $a1 );
    $r2 = boolean2string( $a2 );

    // output
    var_dump( $r1 );
    var_dump( $r2 );
