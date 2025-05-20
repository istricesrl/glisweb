<?php

    /**
     * server e profili Mapquest
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     * 
     * 
     */

    // configurazione extra
    if( isset( $cx['mapquest'] ) ) {
        $cf['mapquest'] = array_replace_recursive( $cf['mapquest'], $cx['mapquest'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['mapquest']                    = &$cf['mapquest'];

    /**
     * collegamento scorciatoie
     * ========================
     * 
     * 
     */

    // link al profilo corrente
    $cf['mapquest']['profile']            = &$cf['mapquest']['profiles'][ $cf['site']['status'] ];

    // link al server corrente
    if( ! empty( $cf['mapquest']['profile']['servers'] ) ) {
        $cf['mapquest']['server']        = &$cf['mapquest']['servers'][ current( $cf['mapquest']['profile']['servers'] ) ];
    } else {
        $cf['mapquest']['server']            = NULL;
    }
