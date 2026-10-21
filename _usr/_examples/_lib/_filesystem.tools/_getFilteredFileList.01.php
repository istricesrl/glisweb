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
    $d = 'tmp/example/' . microtime( true );
    $f3a = $d . '/f3.txt';
    $f3b = $d . '/f3.log';
    $f3c = $d . '/f3.ini';

    // output
    var_dump( $d );

    // stringa da scrivere
    $s = 'A';

    // percorso assoluto
    $c3a = writeToFile( $s, $f3a );
    $c3b = writeToFile( $s, $f3b );
    $c3c = writeToFile( $s, $f3c );

    // output
    var_dump( $c3a );
    var_dump( $c3b );
    var_dump( $c3c );

    // output
    var_dump( getFilteredFileList( $d, '*.log' ) );
