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
    $f = 'tmp/example/' . microtime( true ) . '/';

    // output
    var_dump( $f );

    // creo la cartella
    $c = checkFolder( $f );

    // percorso assoluto
    $d = deleteDir( $f );

    // output
    var_dump( $c );
    var_dump( $d );
