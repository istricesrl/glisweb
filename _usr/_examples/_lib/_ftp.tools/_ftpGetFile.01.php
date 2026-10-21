<?php

    /**
     * file di esempio per la funzione ftpListFiles()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $f = 'tmp/example/' . microtime( true ) . '.txt';
    $r = '/tmp/example/downloads/' . basename( $f );
    $u = '/tmp/example/' . time() . '/' . basename( $f );

    // percorso assoluto
    $d = writeToFile( time(), $f );

    // connessione al server FTP
    $conn = ftpConnect( $cf['ftp']['server'] );

    // upload del file
    ftpPutFile( $conn, $f, $u );

    // download del file
    ftpGetFile( $conn, $u, $r );

    // verifica del download
    var_dump( trim( file_get_contents( getFullPath( $r ) ) ) );

    // chiusura della connessione
    ftpClose( $conn );
