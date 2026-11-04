<?php

    /**
     * file di esempio per la funzione trashFile()
     *
     * sposta un file nel cestino e verifica che non sia più al suo posto e che sia nella cartella del giorno, con il suo
     * percorso relativo; alla fine toglie dal cestino la copia di prova
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $f = 'tmp/example/' . microtime( true ) . '.txt';

    // posizione attesa nel cestino
    $t = DIR_TMP_GARBAGE . date( 'Ymd' ) . '/' . $f;

    // output
    var_dump( $f );

    // creo il file
    $c = checkFile( $f );

    // sposto il file nel cestino
    $d = trashFile( $f );

    // output
    var_dump( $c );
    var_dump( $d );
    var_dump( ! file_exists( getFullPath( $f ) ) );
    var_dump( file_exists( $t ) );

    // un file che non c'è vale come già cestinato, come per deleteFile()
    var_dump( trashFile( $f ) );

    // tolgo la copia di prova dal cestino
    var_dump( deleteFile( $t ) );
