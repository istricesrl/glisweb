<?php

    /**
     * server e profili SMTP
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     * 
     * 
     */

    // configurazione extra
    if( isset( $cx['smtp'] ) ) {
        $cf['smtp'] = array_replace_recursive( $cf['smtp'], $cx['smtp'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['smtp'] ) ) {
        $cf['smtp'] = array_replace_recursive( $cf['smtp'], $cf['site']['smtp'] );
    }

    /**
     * collegamento scorciatoie
     * ========================
     * 
     * 
     */

    // link al profilo corrente
    $cf['smtp']['profile']            = &$cf['smtp']['profiles'][ $cf['site']['status'] ];

    // link al server corrente
    if( isset( $cf['smtp']['profile']['servers'] ) && is_array( $cf['smtp']['profile']['servers'] ) ) {
        $cf['smtp']['server']        = &$cf['smtp']['servers'][ current( $cf['smtp']['profile']['servers'] ) ];
    } else {
        $cf['smtp']['server']        = NULL;
    }

    // debug
    // print_r( $cf['contents']['pages']['licenza']['content'] );
    // print_r($cf['smtp'] );
