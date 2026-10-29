<?php

    /**
     * server e profili FTP
     *
     *
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     * 
     * 
     */

    // configurazione extra
    if( isset( $cx['ftp'] ) ) {
        $cf['ftp'] = array_replace_recursive( $cf['ftp'], $cx['ftp'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['ftp'] ) ) {
        $cf['ftp'] = array_replace_recursive( $cf['ftp'], $cf['site']['ftp'] );
    }

    /**
     * collegamento scorciatoie
     * ========================
     * 
     * 
     */

    // server FTP di prova durante i test: _src/_sh/_codeception.run.sh lo avvia su 127.0.0.1 e ne scrive porta e password
    // in var/test/ftp.mock; come per var/test/recaptcha.off ( _115.google.php ) non vale in produzione e scade dopo
    // un'ora, e finche' c'e' tutto il sito DEV usa quel server al posto del suo, cosi' i test non scrivono su un FTP vero
    if( substr( SITE_STATUS, 0, strlen( PRODUCTION ) ) != PRODUCTION && file_exists( DIR_VAR . 'test/ftp.mock' ) && filemtime( DIR_VAR . 'test/ftp.mock' ) > time() - 3600 ) {
        $ftpTest = file( DIR_VAR . 'test/ftp.mock', FILE_IGNORE_NEW_LINES );
        $cf['ftp']['servers']['test'] = array( 'address' => '127.0.0.1', 'port' => (int) $ftpTest[0], 'username' => 'test', 'password' => $ftpTest[1] );
        $cf['ftp']['profiles'][ $cf['site']['status'] ]['servers'] = array( 'test' );
    }

    // link al profilo corrente
    $cf['ftp']['profile']            = &$cf['ftp']['profiles'][ $cf['site']['status'] ];

    // link al server corrente
    if( isset( $cf['ftp']['profile']['servers'] ) && is_array( $cf['ftp']['profile']['servers'] ) ) {
        $cf['ftp']['server']        = &$cf['ftp']['servers'][ current( $cf['ftp']['profile']['servers'] ) ];
    } else {
        $cf['ftp']['server']        = NULL;
    }

    // debug
    // print_r( $cf['contents']['pages']['licenza']['content'] );
    // print_r($cf['ftp'] );
