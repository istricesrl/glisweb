<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     *
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
    if( isset( $cx['debug'] ) ) {
        $cf['debug'] = array_replace_recursive( $cf['debug'], $cx['debug'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento a $ct
    $ct['debug'] = &$cf['debug'];

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // print_r( $cf['debug'] );
    // error_reporting( E_ALL );
    // ini_set( 'display_errors', TRUE );
    // echo 'OUTPUT';
