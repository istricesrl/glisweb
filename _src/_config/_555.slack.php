<?php

    /**
     * server e profili Slack
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
    if( isset( $cx['slack'] ) ) {
        $cf['slack'] = array_replace_recursive( $cf['slack'], $cx['slack'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['slack'] ) ) {
        $cf['slack'] = array_replace_recursive( $cf['slack'], $cf['site']['slack'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['slack']                        = &$cf['slack'];

    /**
     * collegamento scorciatoie
     * ========================
     * 
     * 
     */

    // link al profilo corrente
    $cf['slack']['profile']             = &$cf['slack']['profiles'][ $cf['site']['status'] ];
