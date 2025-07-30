<?php

    /**
     * applicazione delle configurazioni dei bookmarks
     * 
     * 
     * 
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
    if( isset( $cx['bookmarks'] ) ) {
        $cf['bookmarks'] = array_replace_recursive( $cf['bookmarks'], $cx['bookmarks'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['bookmarks'] = &$cf['bookmarks'];

    /**
     * collegamento dei bookmarks alla sessione
     * ========================================
     * 
     * 
     */

    // sincronizzazione dei bookmarks con la sessione
    foreach( $cf['bookmarks'] as $section => $details ) {
        if( isset( $_SESSION['__work__'][ $section ] ) ) {
            $_SESSION['__work__'][ $section ] = array_replace_recursive(
                $_SESSION['__work__'][ $section ],
                $details
            );
        }
    }

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // dieText( print_r( $cf['site'], true ) );
    // echo 'OUTPUT';
