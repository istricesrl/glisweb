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
        'prova fileTrimLines riga 1',
        'prova fileTrimLines riga 2',
        'prova fileTrimLines riga 3'
    );

    // percorso assoluto
    $d = writeArrayToFile( $s, $f );

    // output
    var_dump( $f );
    var_dump( $d );
    var_dump( fileTrimLines( $f, 1 ) );
    var_dump( readArrayFromFile( $f ) );
