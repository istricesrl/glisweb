<?php

    /**
     * file di esempio per la funzione openFile()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // debug
     error_reporting( E_ALL );
     ini_set( 'display_errors', TRUE );

    // dati
    $d = 'col1;col2;col3' . "\n" . 'val1;val2;val3' . "\n";

    // debug
    var_dump( $d );

    // faccio un'ipotesi sul separatore del file
    $s = guessCsvSeparator( $d );

    // output
    var_dump( $s );
    