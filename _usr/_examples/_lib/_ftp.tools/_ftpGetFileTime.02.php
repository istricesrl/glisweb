<?php

    /**
     * file di esempio per la funzione ftpGetFileTime() in SFTP
     *
     * la data di ultima modifica di un file appena caricato, e false per un file che non c'e'
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $f = 'tmp/example/' . microtime( true ) . '.txt';
    $u = 'example/' . time() . '/' . basename( $f );

    // percorso assoluto
    $d = writeToFile( time(), $f );

    // connessione al server SFTP ( durante i test e' quello di prova, test.sftp )
    $conn = ftpConnect( $cf['ftp']['servers']['test.sftp'] );

    // upload del file
    $inizio = time() - 60;
    ftpPutFile( $conn, $f, $u );

    // data del file caricato e di uno che non c'e'
    var_dump( ftpGetFileTime( $conn, $u ) >= $inizio );
    var_dump( ftpGetFileTime( $conn, $u . '.inesistente' ) );

    // chiusura della connessione
    ftpClose( $conn );
