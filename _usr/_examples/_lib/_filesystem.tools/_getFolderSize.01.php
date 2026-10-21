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
    $f1 = $d . '/f1.txt';
    $f2 = $d . '/f2.txt';

    // output
    var_dump( $d );

    // stringa da scrivere
    $s = 'A';

    // percorso assoluto
    $c1 = writeToFile( $s, $f1 );
    $c2 = writeToFile( $s, $f2 );

    // output
    var_dump( $c1 );
    var_dump( $c2 );

    // output
    var_dump( getFolderSize( $d ) );
