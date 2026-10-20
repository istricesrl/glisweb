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
    $a[0] = logLvl2string( 0 );
    $a[1] = logLvl2string( 1 );
    $a[2] = logLvl2string( 2 );
    $a[3] = logLvl2string( 3 );
    $a[4] = logLvl2string( 4 );
    $a[5] = logLvl2string( 5 );
    $a[6] = logLvl2string( 6 );
    $a[7] = logLvl2string( 7 );
    $a[8] = logLvl2string( 8 );

    // output
    var_dump( $a );
