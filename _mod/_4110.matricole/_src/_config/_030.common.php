<?php

    /**
     * 
     * 
     * 
     * @todo documentare
     * 
     */

    // opzioni del modulo
    $cf['matricole']['scadenze']        = false;
    
    // configurazione extra
    if( isset( $cx['matricole'] ) ) {
        $cf['matricole'] = array_replace_recursive( $cf['matricole'], $cx['matricole'] );
    }
    
    // collegamento all'array $ct
    $ct['matricole']                    = &$cf['matricole'];
