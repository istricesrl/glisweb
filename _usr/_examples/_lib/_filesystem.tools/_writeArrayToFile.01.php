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
    $s = array( 
        'prova writeArrayToFile riga 1',
        'prova writeArrayToFile riga 2'
    );

    // percorso assoluto
    $d = writeArrayToFile( $s, $f );

    // output
    var_dump( $f );
    var_dump( $d );
    var_dump( readFromFile( $f ) );
