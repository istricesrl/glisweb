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

    // percorso assoluto
    $d = writeToFile( time(), $f );

    // connessione al server FTP
    $conn = ftpConnect( $cf['ftp']['server'] );

    // verifica della connessione
    var_dump( ftpPutFile( $conn, $f, '/tmp/example/' . time() . '/' . basename( $f ) ) );

    // chiusura della connessione
    ftpClose( $conn );
