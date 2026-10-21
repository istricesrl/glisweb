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
    $a = "\xEF\xBB\xBFHello, world!";

    // applicazione della funzione
    $r = removeBom( $a );

    // output
    var_dump( $r );
