<?php

    /**
     * file di esempio per la funzione openFile()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // debug
     error_reporting( E_ALL );
     ini_set( 'display_errors', TRUE );

    // scrivo i dati di test
    $d = "col1;col2;col3\nval1;val2;val3\n";

    // debug
    // var_dump( $f );
    var_dump( $d );

    // leggo il file CSV in un array di array associativi
    $a = csvString2array( $d );

    // output
    var_dump( $a );
