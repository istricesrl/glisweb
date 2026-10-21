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
    $d = checkFile( $f );

    // output
    var_dump( $d );
    var_dump( file_exists( getFullPath( $f ) ) );
