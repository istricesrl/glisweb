<?php

    /**
     * file di esempio per la funzione string2array()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // conversioni
    $s1 = 'stringa  di  prova 01';
    $s2 = 'stringa ++di prova 02';
    $s3 = 'stringaaaa di prova 03';

    // riduzione dei caratteri doppi
    $r1 = riduciCaratteriDoppi( $s1 );
    $r2 = riduciCaratteriDoppi( $s2, '+' );
    $r3 = riduciCaratteriDoppi( $s3, 'a' );

    // output
    var_dump( $r1 );
    var_dump( $r2 );
    var_dump( $r3 );
