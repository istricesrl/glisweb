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
        'key 1' => 'prova writeKeyValueArrayToFile riga 1',
        'key 2' => 'prova writeKeyValueArrayToFile riga 2'
    );

    // scrivo l'array associativo
    $d = writeKeyValueArrayToFile( $s, $f );

    // output
    var_dump( $f );
    var_dump( $d );
    var_dump( readArrayFromFile( $f ) );
