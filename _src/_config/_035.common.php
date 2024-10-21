<?php

    /**
     * applicazione delle configurazioni di uso comune
     *
     *
     *
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
    if( isset( $cx['common'] ) ) {
        $cf['common'] = array_replace_recursive( $cf['common'], $cx['common'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['common'] = &$cf['common'];

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // dieText( print_r( $cf['site'], true ) );
    // echo 'OUTPUT';
