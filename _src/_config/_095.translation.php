<?php

    /**
     * tabella di traduzione
     *
     *
     *
     *
     *
     * TODO documentare
     *
     * TODO usare glob per trovare i dizionari (non limitarsi a 'generic')
     * TODO ogni modulo dovrebbe avere i suoi dizionari
     * TODO completare l'inserimento dei dizionari
     *
     *
     *
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     * 
     * 
     */

    // configurazione extra
    if( isset( $cx['tr'] ) ) {
        $cf['tr'] = array_replace_recursive( $cf['tr'], $cx['tr'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // rendo le tabelle di traduzione disponibili al template
    $ct['tr'] = &$cf['tr'];

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // print_r( $arrayDizionari );
    // echo DIR_ETC_DICTIONARIES . '_*.{' . LINGUE_ATTIVE . '}.php' . PHP_EOL;
    // echo DIR_MOD_ATTIVI_ETC_LOC . '_*.{' . LINGUE_ATTIVE . '}.php' . PHP_EOL;
    // echo 'OUTPUT';
