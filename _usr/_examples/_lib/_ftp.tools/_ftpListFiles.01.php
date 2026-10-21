<?php

    /**
     * file di esempio per la funzione ftpListFiles()
     * 
     * 
     * 
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // connessione al server FTP
    $conn = ftpConnect( $cf['ftp']['server'] );

    // verifica della connessione
    var_dump( ftpListFiles( $conn, '/' ) );
    var_dump( ftpListFiles( $conn, '/var' ) );
    var_dump( ftpListFiles( $conn, '/var/esempio' ) );

    // chiusura della connessione
    ftpClose( $conn );
