<?php

    /**
     * file di esempio per la funzione openFile()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso ( il dataserver di Istrice, come _copyFile.05.php: fino al 27/11/2026 era calabash.videoarts.eu, col certificato autofirmato )
    $s = 'https://dataserver.istricesrl.com/geografia/01.update.stati.csv';
    $d = 'tmp/example/' . ( microtime( true ) + 1000.0 ) . '/';
    $f = basename( $s );

    // output
    var_dump( $s );
    var_dump( $d );

    // creo le cartelle
    $j = checkFolder( $d );

    // output
    var_dump( $j );

    // sposto il file
    $m = copyFile( $s, $d );

    // output
    var_dump( $m );

    // output
    var_dump( file_exists( getFullPath( $d . $f ) ) );
