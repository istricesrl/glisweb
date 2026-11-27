<?php

    /**
     * file di esempio per la funzione ftpPutFile() in SFTP
     *
     * il percorso remoto senza barra iniziale vale dalla cartella di login, e le cartelle che mancano si creano
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $f = 'tmp/example/' . microtime( true ) . '.txt';

    // percorso assoluto
    $d = writeToFile( time(), $f );

    // connessione al server SFTP ( durante i test e' quello di prova, test.sftp )
    $conn = ftpConnect( $cf['ftp']['servers']['test.sftp'] );

    // caricamento con un percorso relativo alla cartella di login
    var_dump( ftpPutFile( $conn, $f, 'example/' . time() . '/' . basename( $f ) ) );

    // chiusura della connessione
    ftpClose( $conn );
