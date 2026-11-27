<?php

    /**
     * file di esempio per la funzione ftpGetFile() in SFTP
     *
     * carica un file e lo riscarica
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $f = 'tmp/example/' . microtime( true ) . '.txt';
    $r = '/tmp/example/downloads/' . basename( $f );
    $u = 'example/' . time() . '/' . basename( $f );

    // percorso assoluto
    $d = writeToFile( time(), $f );

    // connessione al server SFTP ( durante i test e' quello di prova, test.sftp )
    $conn = ftpConnect( $cf['ftp']['servers']['test.sftp'] );

    // upload del file
    ftpPutFile( $conn, $f, $u );

    // download del file
    ftpGetFile( $conn, $u, $r );

    // verifica del download
    var_dump( trim( file_get_contents( getFullPath( $r ) ) ) );

    // chiusura della connessione
    ftpClose( $conn );
