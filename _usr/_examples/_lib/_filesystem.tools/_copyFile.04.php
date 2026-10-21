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
    $s = 'https://calabash.videoarts.eu/va.current.version';
    $d = 'tmp/example/' . ( microtime( true ) + 1000.0 ) . '/';
    $f = ( microtime( true ) + 2000.00 ) . '.txt';

    // output
    var_dump( $s );
    var_dump( $d );

    // creo le cartelle
    $j = checkFolder( $d );

    // output
    var_dump( $j );

    // sposto il file
    $m = copyFile( $s, $d . $f );

    // output
    var_dump( $m );

    // output
    var_dump( file_exists( getFullPath( $d . $f ) ) );
