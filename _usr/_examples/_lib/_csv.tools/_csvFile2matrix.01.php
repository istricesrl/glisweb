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
    $f = 'tmp/example/' . microtime( true ) . '.csv';

    // debug
     error_reporting( E_ALL );
     ini_set( 'display_errors', TRUE );

    // scrivo i dati di test
    $h = openFile( DIR_BASE . $f, 'w+' );
    fwrite( $h, "col1;col2;col3\n" );
    fwrite( $h, "val1;val2;val3\n" );
    fclose( $h );

    // debug
    // var_dump( $f );
     var_dump( file( DIR_BASE . $f ) );

    // leggo il file CSV in un array di array associativi
    $a = csvFile2matrix( DIR_BASE . $f );

    // output
    var_dump( $a );
