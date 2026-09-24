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
