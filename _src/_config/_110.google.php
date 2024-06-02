<?php

    /**
     * server e profili google
     *
     * introduzione
     * ============
     * L'array di configurazione dei servizi Google è strutturato come da prassi in profili:
     * 
     * 
     *                              +--- DEVELOPEMENT
     *                              |
     * $cf['google']['profiles'] ---+--- TESTING
     *                              |
     *                              +--- PRODUCTION
     *
     * Per ognuno di questi profili è possibile specificare una sotto chiave per ogni servizio Google che
     * si vuole utilizzare:
     * 
     *                                              +--- recaptcha
     *                                              |
     * $cf['google']['profiles'][ DEVELOPEMENT ] ---+--- analytics
     *                                              |
     *                                              +--- maps
     * 
     * Ogni servizio Google può avere una propria configurazione, che viene specificata come sotto array.
     * 
     * 
     * Analytics
     * ---------
     * 
     * 
     * - https://developers.google.com/analytics/help
     *
     * 
     * 
     * reCAPTCHA
     * ---------
     * 
     * 
     * 
     * 
     * Maps
     * ----
     * 
     * 
     * 
     * 
     * 
     *
     * TODO documentare
     *
     *
     *
     */

    // profili di funzionamento
    $cf['google']['profiles'][ DEVELOPEMENT ]   =
    $cf['google']['profiles'][ TESTING ]        =
    $cf['google']['profiles'][ PRODUCTION ]     = NULL;

    // debug
    // print_r( $cx['google'] );
