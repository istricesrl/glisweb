<?php

    /**
     * fusione della configurazione del modulo documenti
     *
     * Unisce ai default di _030.common.php la chiave documenti della configurazione del deploy e del sito, e la
     * collega a $ct perché i template la leggano come documenti.
     *
     * @file
     *
     */

    // configurazione extra
    if( isset( $cx['documenti'] ) ) {
        $cf['documenti'] = array_replace_recursive( $cf['documenti'], $cx['documenti'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['documenti'] ) ) {
        $cf['documenti'] = array_replace_recursive( $cf['documenti'], $cf['site']['documenti'] );
    }

    // collegamento all'array $ct
    $ct['documenti']                                    = &$cf['documenti'];
