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
    $a = "2024-08-30";

    // applicazione della funzione
    $r = date2string( $a );

    // output
    var_dump( $r );
