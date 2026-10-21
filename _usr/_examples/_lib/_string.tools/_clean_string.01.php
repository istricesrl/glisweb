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
    $a = "Hello\x00\x1F, \xC2\x80world! \xE2\x80\x8F\xE2\x80\xA4\xE2\x81\x9F";
    
    // applicazione della funzione
    $r = clean_string( $a );

    // output
    var_dump( $r );
