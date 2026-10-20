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
    $a = "stringa di prova 01";

    // applicazione della funzione
    $r1 = riduciStringa( $a, 6 );
    $r2 = riduciStringa( $a, 7 );
    $r3 = riduciStringa( $a, 7, '+' );

    // output
    var_dump( $r1 );
    var_dump( $r2 );
    var_dump( $r3 );
