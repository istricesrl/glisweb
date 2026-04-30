<?php

    /**
     * 
     * 
     * TODO documentare
     * 
     */

    /**
     * sezione Teamsystem
     * ==================
     * 
     * 
     */

    // configurazione extra
    if( isset( $cx['teamsystem'] ) ) {
        $cf['teamsystem'] = array_replace_recursive( $cf['teamsystem'], $cx['teamsystem'] );
    }

    // collegamento all'array $ct
    $ct['teamsystem'] = &$cf['teamsystem'];

    // link al profilo corrente
    $cf['teamsystem']['profile'] = &$cf['teamsystem']['profiles'][ SITE_STATUS ];

    /**
     * sezione Zucchetti
     * =================
     * 
     * 
     */

    // configurazione extra
    if( isset( $cx['zucchetti'] ) ) {
        $cf['zucchetti'] = array_replace_recursive( $cf['zucchetti'], $cx['zucchetti'] );
    }

    // collegamento all'array $ct
    $ct['zucchetti'] = &$cf['zucchetti'];

    // link al profilo corrente
    $cf['zucchetti']['profile'] = &$cf['zucchetti']['profiles'][ SITE_STATUS ];

    /**
     * sezione Emailable
     * =================
     *
     *
     */

    // configurazione extra
    if( isset( $cx['emailable'] ) ) {
        $cf['emailable'] = array_replace_recursive( $cf['emailable'], $cx['emailable'] );
    }

    // collegamento all'array $ct
    $ct['emailable'] = &$cf['emailable'];

    // link al profilo corrente
    $cf['emailable']['profile'] = &$cf['emailable']['profiles'][ SITE_STATUS ];
