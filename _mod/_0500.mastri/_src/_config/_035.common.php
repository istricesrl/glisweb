<?php

    /**
     * applicazione delle configurazioni del modulo mastri
     *
     * Fonde il ramo mastri di src/config.json sui default dichiarati in _030.common.php.
     *
     * @file
     *
     */

    // configurazione extra
    if( isset( $cx['mastri'] ) ) {
        $cf['mastri'] = array_replace_recursive( $cf['mastri'], $cx['mastri'] );
    }

    // collegamento all'array $ct
    $ct['mastri'] = &$cf['mastri'];
