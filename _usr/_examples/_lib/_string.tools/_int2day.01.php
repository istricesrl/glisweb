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
    $a[0] = int2day( 1 );
    $a[1] = int2day( 2 );
    $a[2] = int2day( 3 );
    $a[3] = int2day( 4 );
    $a[4] = int2day( 5 );
    $a[5] = int2day( 6 );
    $a[6] = int2day( 7 );

    // output
    var_dump( $a );
