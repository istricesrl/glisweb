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
    $a[0] = reportLvl2string( 1 );
    $a[1] = reportLvl2string( 2 );
    $a[2] = reportLvl2string( 4 );
    $a[3] = reportLvl2string( 8 );
    $a[4] = reportLvl2string( 16 );
    $a[5] = reportLvl2string( 32 );
    $a[6] = reportLvl2string( 64 );
    $a[7] = reportLvl2string( 128 );
    $a[8] = reportLvl2string( 256 );
    $a[9] = reportLvl2string( 512 );
    $a[10] = reportLvl2string( 1024 );
    $a[11] = reportLvl2string( 2048 );
    $a[12] = reportLvl2string( 4096 );

    // output
    var_dump( $a );
