<?php

    /**
     *
     *
     *
     * TODO documentare
     *
     *
     */

    // configurazione extra
    if( isset( $cx['auth'] ) ) {
        $cf['auth'] = array_replace_recursive( $cf['auth'], $cx['auth'] );
    }

    // debug
    // print_r( $cf['auth'] );
