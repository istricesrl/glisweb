<?php

    /**
     * server e profili openai
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
    if( isset( $cx['openai'] ) ) {
        $cf['openai'] = array_replace_recursive( $cf['openai'], $cx['openai'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['openai']                       = &$cf['openai'];

    /**
     * collegamento scorciatoie
     * ========================
     * 
     * 
     */

    // link al profilo corrente
    $cf['openai']['profile']            = &$cf['openai']['profiles'][ $cf['site']['status'] ];

    // link al server corrente
    if( ! empty( $cf['openai']['profile']['servers'] ) ) {
        $cf['openai']['server']         = &$cf['openai']['servers'][ current( $cf['openai']['profile']['servers'] ) ];
    } else {
        $cf['openai']['server']         = NULL;
    }
