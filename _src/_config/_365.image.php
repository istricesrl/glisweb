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

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     * 
     * 
     */

    // configurazione extra
    if( isset( $cx['image'] ) ) {
        $cf['image'] = array_replace_recursive( $cf['image'], $cx['image'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collego l'array $ct
	$ct['image'] = &$cf['image'];

    // debug
    // print_r( $cf['image'] );
