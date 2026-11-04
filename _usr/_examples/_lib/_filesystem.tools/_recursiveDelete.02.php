<?php

    /**
     * file di esempio per la funzione recursiveDelete()
     *
     * svuota una cartella risparmiando un nome del primo livello, come fa _tmp.clean.php col cestino: il nome escluso
     * resta con tutto il suo contenuto, il resto va via, e la cartella stessa resta
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $f = 'tmp/example/' . microtime( true ) . '/';

    // output
    var_dump( $f );

    // un file e una sottocartella da cancellare, e una cartella nascosta da tenere
    var_dump( checkFile( $f . 'via.txt' ) );
    var_dump( checkFile( $f . 'subfolder/via.txt' ) );
    var_dump( checkFile( $f . '.garbage/20000101/resta.txt' ) );

    // svuoto la cartella tranne .garbage
    var_dump( recursiveDelete( $f, false, array( '.garbage' ) ) );

    // output
    var_dump( ! file_exists( getFullPath( $f . 'via.txt' ) ) );
    var_dump( ! file_exists( getFullPath( $f . 'subfolder' ) ) );
    var_dump( file_exists( getFullPath( $f . '.garbage/20000101/resta.txt' ) ) );

    // tolgo la cartella di prova
    var_dump( recursiveDelete( $f ) );
