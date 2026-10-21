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
    $a = 1725031915;

    // applicazione della funzione
    $r = ts2string( $a );

    // output
    var_dump( $r );
