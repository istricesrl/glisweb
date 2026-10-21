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

    // creo la cartella di base
    $c = checkFolder( $f );

    // creo una sottocartella e un file
    $s = checkFile( $f . 'subfolder/' . microtime( true ) . '.txt' );

    // percorso assoluto
    $d = emptyFolder( $f );

    // output
    var_dump( $c );
    var_dump( $s );
    var_dump( $d );
    var_dump( is_dir( getFullPath( $f ) ) );
