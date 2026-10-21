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

    // creo il file
    $c = checkFile( $f );

    // percorso assoluto
    $d = deleteFile( $f );

    // output
    var_dump( $c );
    var_dump( $d );
