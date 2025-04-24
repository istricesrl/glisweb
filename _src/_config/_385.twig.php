<?php

    /**
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
    if( isset( $cx['twig'] ) ) {
        $cf['twig'] = array_replace_recursive( $cf['twig'], $cx['twig'] );
    }

    // link al profilo corrente
    $cf['twig']['profile'] = &$cf['twig']['profiles'][ $cf['site']['status'] ];

    // controllo la cartella per la cache di Twig
    if( isset( $cf['twig']['profile']['cache'] ) ) {
        fullPath( $cf['twig']['profile']['cache'] );
        checkFolder( $cf['twig']['profile']['cache'] );
    }
