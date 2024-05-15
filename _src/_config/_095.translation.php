<?php

    /**
     * tabella di traduzione
     *
     *
     *
     *
     *
     *
     * TODO usare glob per trovare i dizionari (non limitarsi a 'generic')
     * TODO ogni modulo dovrebbe avere i suoi dizionari
     * TODO documentare
     * TODO completare l'inserimento dei dizionari
     *
     *
     *
     */

    // configurazione extra
    if( isset( $cx['tr'] ) ) {
        $cf['tr'] = array_replace_recursive( $cf['tr'], $cx['tr'] );
    }

    // rendo le tabelle di traduzione disponibili al template
    $ct['tr'] = &$cf['tr'];

    // debug
    // print_r( $arrayDizionari );
    // echo DIR_ETC_DICTIONARIES . '_*.{' . LINGUE_ATTIVE . '}.php' . PHP_EOL;
    // echo DIR_MOD_ATTIVI_ETC_LOC . '_*.{' . LINGUE_ATTIVE . '}.php' . PHP_EOL;
    // echo 'OUTPUT';
