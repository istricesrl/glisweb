<?php

    /**
     * dichiarazione dei template per la posta
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
    if( isset( $cx['mail'] ) ) {
        $cf['mail'] = array_replace_recursive( $cf['mail'], $cx['mail'] );
    }
