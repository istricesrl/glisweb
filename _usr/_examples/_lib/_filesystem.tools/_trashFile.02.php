<?php

    /**
     * file di esempio per la funzione trashFile()
     *
     * cestina due volte lo stesso percorso nello stesso giorno, in un cestino di prova: il secondo file non deve
     * sovrascrivere il primo ma finire nella cartella AAAAMMGG.2
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // cestino di prova e file
    $g = 'tmp/example/' . microtime( true ) . '.garbage/';
    $f = 'tmp/example/' . microtime( true ) . '.txt';

    // output
    var_dump( $g );
    var_dump( $f );

    // primo file
    writeToFile( 'primo', $f );
    var_dump( trashFile( $f, $g ) );

    // secondo file con lo stesso percorso
    writeToFile( 'secondo', $f );
    var_dump( trashFile( $f, $g ) );

    // output
    var_dump( readStringFromFile( $g . date( 'Ymd' ) . '/' . $f, true ) === 'primo' );
    var_dump( readStringFromFile( $g . date( 'Ymd' ) . '.2/' . $f, true ) === 'secondo' );

    // tolgo il cestino di prova
    var_dump( recursiveDelete( $g ) );
