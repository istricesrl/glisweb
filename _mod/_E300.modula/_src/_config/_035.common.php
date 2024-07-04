<?php

    /**
     * applicazione delle configurazioni di uso comune
     *
     * questo file attualmente non è utilizzato nel modulo base ma può essere usato nei moduli o nelle personalizzazioni
     *
     *
     *
     *
     *
     */

    // configurazione extra
    if( isset( $cx['modula'] ) ) {
        $cf['modula'] = array_replace_recursive( $cf['modula'], $cx['modula'] );
    }

    // collegamento all'array $ct
    $ct['modula'] = &$cf['modula'];
