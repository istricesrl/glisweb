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
    $bytes = writeByte( 20 );
    $Kb = writeByte( 2000 );
    $Mb = writeByte( 2000000 );
    $Gb = writeByte( 2000000000 );
    $Tb = writeByte( 2000000000000 );

    // output
    var_dump( $bytes );
    var_dump( $Kb );
    var_dump( $Mb );
    var_dump( $Gb );
    var_dump( $Tb );
