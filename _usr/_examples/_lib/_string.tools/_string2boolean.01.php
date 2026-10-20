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
    $a1 = "True";
    $a2 = 1;
    $a3 = "False";

    // applicazione della funzione
    $r1 = string2boolean( $a1 );
    $r2 = string2boolean( $a2 );
    $r3 = string2boolean( $a3 );

    // output
    var_dump( $r1 );
    var_dump( $r2 );
    var_dump( $r3 );
