<?php

    /**
     * server e profili Google
     *
     * introduzione
     * ============
     * In questo file vengono integrati i dati dichiarati al runlevel 110 con quelli presenti nei file di configurazione
     * JSON/YAML dopodiché la chiave $cf['google'] viene collegata a $ct['google'] per dare visibilità al template manager
     * delle informazioni sui profili. Infine il profilo relativo allo stato corrente del sito viene collegato alla
     * scorciatoia $cf['google']['profile'].
     *
     *
     *
     *
     * TODO documentare
     *
     *
     *
     */

    // configurazione extra
    if( isset( $cx['google'] ) ) {
        $cf['google'] = array_replace_recursive( $cf['google'], $cx['google'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['google'] ) ) {
        $cf['google'] = array_replace_recursive( $cf['google'], $cf['site']['google'] );
    }

    // collegamento all'array $ct
    $ct['google'] = &$cf['google'];

    // link al profilo corrente
    $cf['google']['profile'] = &$cf['google']['profiles'][ SITE_STATUS ];

    /*

        // CSP
        if( ! empty( $cf['google']['profile']['recaptcha'] ) ) {
            $ct['page']['csp']['script-src'][] = 'www.gstatic.com';
        }

    */
