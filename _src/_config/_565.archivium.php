<?php

    /**
     * server e profili Archivium
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
    if( isset( $cx['archivium'] ) ) {
        $cf['archivium'] = array_replace_recursive( $cf['archivium'], $cx['archivium'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['archivium'] ) ) {
        $cf['archivium'] = array_replace_recursive( $cf['archivium'], $cf['site']['archivium'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['archivium']                        = &$cf['archivium'];

    /**
     * collegamento scorciatoie
     * ========================
     * 
     * 
     */

    // link al profilo corrente
    $cf['archivium']['profile']             = &$cf['archivium']['profiles'][ $cf['site']['status'] ];
