<?php

    /**
     * file di esempio per la funzione string2array()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // token da controllare
    $j = 'prova+token/clean=1';

    // controllo del token JWT
    $a = cleanJwt( $j );

    // output 
    var_dump( $a );