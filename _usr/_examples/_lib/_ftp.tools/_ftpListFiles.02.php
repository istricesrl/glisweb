<?php

    /**
     * file di esempio per la funzione ftpListFiles() in SFTP
     *
     * elenca una cartella appena creata con un file dentro
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $f = 'tmp/example/' . microtime( true ) . '.txt';
    $u = 'example/elenco.' . time() . '/' . basename( $f );

    // percorso assoluto
    $d = writeToFile( time(), $f );

    // connessione al server SFTP ( durante i test e' quello di prova, test.sftp )
    $conn = ftpConnect( $cf['ftp']['servers']['test.sftp'] );

    // upload del file
    ftpPutFile( $conn, $f, $u );

    // contenuto della cartella
    var_dump( ftpListFiles( $conn, dirname( $u ) ) );

    // chiusura della connessione
    ftpClose( $conn );
