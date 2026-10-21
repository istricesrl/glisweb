<?php

    /**
     * file di esempio per la funzione copyFile()
     *
     * una risposta HTTP d'errore non è il file: copyFile() restituisce false e non scrive niente
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $s = 'https://dataserver.istricesrl.com/geografia/zz.inesistente.csv';
    $d = 'tmp/example/' . ( microtime( true ) + 1000.0 ) . '/';
    $f = basename( $s );

    // creo le cartelle
    $j = checkFolder( $d );

    // output
    var_dump( $j );

    // copio il file
    $m = copyFile( $s, $d );

    // output
    var_dump( $m === false );
    var_dump( ! file_exists( getFullPath( $d . $f ) ) );
