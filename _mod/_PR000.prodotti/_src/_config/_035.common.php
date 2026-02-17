<?php

    /**
     * 
     * 
     * 
     * TODO documentare
     * 
     */

    // configurazione extra
    if ( isset( $cx['prodotti'] ) ) {
        $cf['prodotti'] = array_replace_recursive($cf['prodotti'], $cx['prodotti']);
    }

    // configurazione extra per sito
    if( isset( $cf['site']['prodotti'] ) ) {
        $cf['prodotti'] = array_replace_recursive( $cf['prodotti'], $cf['site']['prodotti'] );
    }

    // collegamento all'array $ct
    $ct['prodotti']                    = &$cf['prodotti'];
