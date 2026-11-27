<?php

    /**
     * file di esempio per la funzione emptyTrash()
     *
     * in un cestino di prova mette una cartella del giorno vecchia, una di oggi e una che non è una cartella del giorno:
     * l'anteprima non cancella niente, il giro vero toglie solo quella vecchia, e con zero giorni quella di oggi resta
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // cestino di prova
    $g = 'tmp/example/' . microtime( true ) . '.garbage/';

    // output
    var_dump( $g );

    // le tre cartelle, ognuna con un file
    $v = $g . '20000101/tmp/vecchio.txt';
    $o = $g . date( 'Ymd' ) . '/tmp/oggi.txt';
    $a = $g . 'altro/altro.txt';

    var_dump( checkFile( $v ) );
    var_dump( checkFile( $o ) );
    var_dump( checkFile( $a ) );

    // anteprima: indica la cartella vecchia e non cancella niente
    $s = emptyTrash( 30, $g, true );
    var_dump( $s === array( getFullPath( $g ) . '20000101/' ) );
    var_dump( file_exists( getFullPath( $v ) ) );

    // giro vero: va via solo la cartella vecchia
    $c = emptyTrash( 30, $g );
    var_dump( $c === array( getFullPath( $g ) . '20000101/' ) );
    var_dump( ! file_exists( getFullPath( $g . '20000101' ) ) );
    var_dump( file_exists( getFullPath( $o ) ) );
    var_dump( file_exists( getFullPath( $a ) ) );

    // con zero giorni vale uno: quello cestinato oggi resta
    var_dump( emptyTrash( 0, $g ) === array() );
    var_dump( file_exists( getFullPath( $o ) ) );

    // tolgo il cestino di prova
    var_dump( recursiveDelete( $g ) );
