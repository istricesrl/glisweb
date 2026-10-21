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
    $s = 'prova readArrayFromFile';

    // percorso assoluto
    $d = writeToFile( $s, $f );

    // output
    var_dump( $f );
    var_dump( $d );
    var_dump( readArrayFromFile( $f ) );
