<?php

    /**
     * file di esempio per la funzione ftpConnect() in SFTP con un'impronta sbagliata
     *
     * se l'impronta della host key non e' quella dichiarata la connessione si rifiuta
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // server SFTP di prova con un'impronta che non e' la sua
    $srv = $cf['ftp']['servers']['test.sftp'];
    $srv['fingerprint'] = str_repeat( '0', 32 );

    // connessione al server SFTP
    var_dump( ftpConnect( $srv ) );
