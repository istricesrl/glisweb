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
    $f = 'tmp/example/' . microtime( true ) . '.txt';

    // output
    var_dump( $f );

    // stringa da scrivere
    $s = 'prova readFromFile';

    // percorso assoluto
    $d = writeToFile( $s, $f );

    // output
    var_dump( $f );
    var_dump( $d );
    var_dump( readFromFile( $f, FILE_READ_AS_STRING ) );
