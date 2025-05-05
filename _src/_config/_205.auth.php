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

    // debug
    // print_r( $cf['auth'] );
