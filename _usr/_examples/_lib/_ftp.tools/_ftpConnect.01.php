<?php

    /**
     * file di esempio per la funzione ftpConnect()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // connessione al server FTP
    $conn = ftpConnect( $cf['ftp']['server'] );

    // verifica della connessione
    var_dump( $conn );

    // chiusura della connessione
    ftpClose( $conn );
