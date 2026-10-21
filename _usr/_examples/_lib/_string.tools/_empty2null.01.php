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
    $a[0] = empty2null( '123', false );
    $a[1] = empty2null( '123', true );
    $a[2] = empty2null( '0', false );
    $a[3] = empty2null( '0', true );
    $a[4] = empty2null( '', false );
    $a[5] = empty2null( '', true );
    $a[6] = empty2null( 'abc', false );
    $a[7] = empty2null( 'abc', true );

    // output
    var_dump( $a );
