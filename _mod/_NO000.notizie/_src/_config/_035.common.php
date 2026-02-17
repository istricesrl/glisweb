<?php

    /**
     * 
     * 
     * 
     * TODO documentare
     * 
     */

    // configurazione extra
    if ( isset( $cx['notizie'] ) ) {
        $cf['notizie'] = array_replace_recursive($cf['notizie'], $cx['notizie']);
    }

    // configurazione extra per sito
    if( isset( $cf['site']['notizie'] ) ) {
        $cf['notizie'] = array_replace_recursive( $cf['notizie'], $cf['site']['notizie'] );
    }

    // collegamento all'array $ct
    $ct['notizie']                    = &$cf['notizie'];
