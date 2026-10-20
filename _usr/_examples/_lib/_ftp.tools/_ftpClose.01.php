<?php

    /**
     * file di esempio per la funzione ftpClose()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // connessione al server FTP
    $conn = ftpConnect( $cf['ftp']['server'] );

    // chiusura della connessione
    var_dump( ftpClose( $conn ) );
