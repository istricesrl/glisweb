<?php

    /**
     * file di esempio per la funzione openFile()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $f = DIR_BASE . 'tmp/example/' . microtime( true ) . '.csv';

    // debug
    var_dump( $f );

    // debug
     error_reporting( E_ALL );
     ini_set( 'display_errors', TRUE );

    // dati
    $d = array(
        array( 'col1', 'col2', 'col3' ),
        array( 'val1', 'val2', 'val3')
    );

    // debug
    var_dump( $d );

    // leggo l'array di stringhe CSV in un array di array associativi
    $a = matrix2csvFile( $d, $f );

    // output
    var_dump( file_get_contents( $f ) );
    