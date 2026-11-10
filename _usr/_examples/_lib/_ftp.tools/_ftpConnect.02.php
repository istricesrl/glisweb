<?php

    /**
     * file di esempio per la funzione ftpConnect() in SFTP
     *
     * in SFTP la connessione e' un array col protocollo, le risorse ssh2 e la cartella di login
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // connessione al server SFTP ( durante i test e' quello di prova, test.sftp )
    $conn = ftpConnect( $cf['ftp']['servers']['test.sftp'] );

    // verifica della connessione
    var_dump( $conn['protocol'] );
    var_dump( $conn['home'] );

    // chiusura della connessione
    ftpClose( $conn );
