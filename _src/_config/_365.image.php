<?php

    /**
     * immagini
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     */

    // configurazione extra
    if( isset( $cx['image'] ) ) {
        $cf['image'] = array_replace_recursive( $cf['image'], $cx['image'] );
    }

    // debug
    // print_r( $cf['image'] );
