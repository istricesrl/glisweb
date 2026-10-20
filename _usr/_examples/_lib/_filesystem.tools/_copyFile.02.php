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
    $s = 'tmp/example/' . microtime( true ) . '/';
    $d = 'tmp/example/' . ( microtime( true ) + 1000.0 ) . '/';
    $f = ( microtime( true ) + 2000.00 ) . '.txt';

    // output
    var_dump( $s );
    var_dump( $d );

    // creo le cartelle
    $h = checkFolder( $s );
    $j = checkFolder( $d );

    // output
    var_dump( $h );
    var_dump( $j );

    // file sorgente
    $s = $s . $f;
    $d = $d . $f;

    // output
    var_dump( $s );
    var_dump( $d );

    // creo il file
    $c = checkFile( $s );

    // output
    var_dump( $c );

    // sposto il file
    $m = copyFile( $s, $d );

    // output
    var_dump( $m );

    // output
    var_dump( file_exists( getFullPath( $d ) ) );
