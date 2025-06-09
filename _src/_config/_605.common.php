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
