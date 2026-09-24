<?php

    /**
     * 
     * 
     * TODO documentare
     * 
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     * 
     * 
     */

    // configurazione extra
    if( isset( $cx['contatti'] ) ) {
        $cf['contatti'] = array_replace_recursive( $cf['contatti'], $cx['contatti'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['contatti'] = &$cf['contatti'];

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // dieText( print_r( $cf['contatti'], true ) );
    // echo 'OUTPUT';
