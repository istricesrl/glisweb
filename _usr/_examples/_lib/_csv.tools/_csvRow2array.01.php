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

    // dati
    $h = array( 'col1', 'col2', 'col3' ); 
    $d = 'val1,val2,val3';

    // debug
    var_dump( $h );
    var_dump( $d );

    // leggo l'array di stringhe CSV in un array di array associativi
    $a = csvRow2array( $d, $h );

    // output
    var_dump( $a );
    