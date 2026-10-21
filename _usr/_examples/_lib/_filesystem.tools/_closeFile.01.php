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

    // apro il file
    $d = openFile( $f );

    // chiudo il file
    $c = closeFile( $d );

    // output
    var_dump( $f );
    var_dump( $c );
