<?php

    /**
     * file di esempio per la funzione glob2custom()
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

    // percorso assoluto
    checkFolder( $f );

    // output
    var_dump( $f );
    var_dump( file_exists( getFullPath( $f ) ) );
