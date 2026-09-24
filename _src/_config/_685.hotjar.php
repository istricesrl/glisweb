<?php

    /**
     * profili Hotjar
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
    if( isset( $cx['hotjar'] ) ) {
        $cf['hotjar'] = array_replace_recursive( $cf['hotjar'], $cx['hotjar'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['hotjar'] ) ) {
        $cf['hotjar'] = array_replace_recursive( $cf['hotjar'], $cf['site']['hotjar'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['hotjar']                    = &$cf['hotjar'];

    /**
     * collegamento scorciatoie
     * ========================
     * 
     * 
     */

    // link al profilo corrente
    $cf['hotjar']['profile']            = &$cf['hotjar']['profiles'][ $cf['site']['status'] ];
