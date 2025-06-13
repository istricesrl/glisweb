<?php

    /**
     * server e profili amazon
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
    if( isset( $cx['amazon'] ) ) {
        $cf['amazon'] = array_replace_recursive( $cf['amazon'], $cx['amazon'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['amazon'] ) ) {
        $cf['amazon'] = array_replace_recursive( $cf['amazon'], $cf['site']['amazon'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['amazon']                    = &$cf['amazon'];

    /**
     * collegamento scorciatoie
     * ========================
     * 
     * 
     */

    // link al profilo corrente
    $cf['amazon']['profile']            = &$cf['amazon']['profiles'][ $cf['site']['status'] ];
