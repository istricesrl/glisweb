<?php

    /**
     * file di esempio per la funzione ftpClose() in SFTP
     *
     * chiude la sessione SSH
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // connessione al server SFTP ( durante i test e' quello di prova, test.sftp )
    $conn = ftpConnect( $cf['ftp']['servers']['test.sftp'] );

    // chiusura della connessione
    var_dump( ftpClose( $conn ) );
