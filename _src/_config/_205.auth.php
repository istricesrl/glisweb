<?php

    /**
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
    if( isset( $cx['auth'] ) ) {
        $cf['auth'] = array_replace_recursive( $cf['auth'], $cx['auth'] );
    }

    /**
     * lettura dell'indice delle sessioni attive
     * =========================================
     * 
     * 
     */

    $cf['auth']['index'] = json_decode( $cf['redis']['connection']->get( REDIS_MULTISITE_SEED ), true );

    // debug
    // print_r( $cf['auth'] );
    // print_r( $cx['auth'] );
    // print_r( $cf['auth']['index'] );
