<?php

    /**
     * server e profili facebook
     *
     *
     *
     * pixel di Fb -> https://www.facebook.com/business/help/952192354843755?id=1205376682832142
     * eventi Fb -> https://www.facebook.com/business/help/402791146561655?id=1205376682832142
     * conversioni Fb -> https://developers.facebook.com/docs/marketing-api/conversions-api/
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
    if( isset( $cx['facebook'] ) ) {
        $cf['facebook'] = array_replace_recursive( $cf['facebook'], $cx['facebook'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['facebook'] ) ) {
        $cf['facebook'] = array_replace_recursive( $cf['facebook'], $cf['site']['facebook'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['facebook']                    = &$cf['facebook'];

    /**
     * collegamento scorciatoie
     * ========================
     * 
     * 
     */

    // link al profilo corrente
    $cf['facebook']['profile']            = &$cf['facebook']['profiles'][ $cf['site']['status'] ];
