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
    $d = checkFolder( $f );
    checkFolder( $f . 'sub1' );
    checkFolder( $f . 'sub2' );

    // output
    var_dump( $d );

    // output
    var_dump( dirTreeToArray( $f ) );
