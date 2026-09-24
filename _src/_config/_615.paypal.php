<?php

    /**
     * server e profili paypal
     *
     *
     *
     *
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
    if( isset( $cx['paypal'] ) ) {
        $cf['paypal'] = array_replace_recursive( $cf['paypal'], $cx['paypal'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['paypal'] ) ) {
        $cf['paypal'] = array_replace_recursive( $cf['paypal'], $cf['site']['paypal'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['paypal']                        = &$cf['paypal'];

    /**
     * collegamento scorciatoie
     * ========================
     * 
     * 
     */

    // link al profilo corrente
    $cf['paypal']['profile']            = &$cf['paypal']['profiles'][ $cf['site']['status'] ];
