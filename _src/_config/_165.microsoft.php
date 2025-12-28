<?php

    /**
     * server e profili microsoft
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

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     * 
     * 
     */

    // configurazione extra
    if( isset( $cx['microsoft'] ) ) {
        $cf['microsoft'] = array_replace_recursive( $cf['microsoft'], $cx['microsoft'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['microsoft'] ) ) {
        $cf['microsoft'] = array_replace_recursive( $cf['microsoft'], $cf['site']['microsoft'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['microsoft'] = &$cf['microsoft'];

    /**
     * scorciatoia per il profilo corrente
     * ===================================
     * 
     * 
     */

    // link al profilo corrente
    $cf['microsoft']['profile'] = &$cf['microsoft']['profiles'][ SITE_STATUS ];
