<?php

    /**
     * file di esempio per la funzione string2array()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    $s = array( 'val1', 'val2', 'val3' );

    // ...
    var_dump( array2string( $s, ';' ) );
