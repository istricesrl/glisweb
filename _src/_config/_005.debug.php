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

    // configurazione extra
    if( isset( $cx['debug'] ) ) {
        $cf['debug'] = array_replace_recursive( $cf['debug'], $cx['debug'] );
    }

    // collegamento a $ct
    $ct['debug'] = &$cf['debug'];

    // debug
    // print_r( $cf['debug'] );
    // error_reporting( E_ALL );
    // ini_set( 'display_errors', TRUE );
    // echo 'OUTPUT';
