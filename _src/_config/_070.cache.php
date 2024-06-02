<?php

    /**
     * configurazione della cache statica delle pagine
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     *
     */

    // debug
    // print_r( $_COOKIE );

    // se è attiva la cache delle pagine
    if( $cf['cache']['profile']['pages'] === true ) {

        // file per la cache della pagina corrente
        $cachefile = DIR_VAR_CACHE_PAGES . md5(
            $_SERVER['SERVER_NAME'] .
            $_SERVER['REQUEST_URI'] .
            serialize( $_REQUEST ) .
            ( ( isset( $_SESSION['__view__'] ) ) ? serialize( $_SESSION['__view__'] ) : NULL ) .
            ( ( isset( $_SESSION['carrello']['spedizione_id_stato'] ) ) ? $_SESSION['carrello']['spedizione_id_stato'] : NULL ) .
            ( ( isset( $_COOKIE['privacy'] ) ) ? $_COOKIE['privacy'] : NULL )
        );

        // costante per il file per la cache della pagina corrente
        define( 'FILE_CACHE_PAGE', $cachefile );

        // costanti per i tempi
        define( 'FILE_CACHE_PAGE_LIMIT', ( strtotime( '-' . ( 18 + rand( 0, 6 ) ) . ' hours' ) ) );
        define( 'FILE_CACHE_PAGE_TIME', ( file_exists( $cachefile ) ) ? filemtime( $cachefile ) : NULL );

        // se il file di cache esiste e non è scaduto
        if( FILE_CACHE_PAGE_TIME > FILE_CACHE_PAGE_LIMIT ) {
            $cacheinfo = PHP_EOL .
            '<!-- cached: ' . date( 'Y/m/d H:i:s', FILE_CACHE_PAGE_TIME ) . ' -->'        . PHP_EOL .
            '<!-- expire: ' . date( 'Y/m/d H:i:s', FILE_CACHE_PAGE_LIMIT ) . ' -->'        . PHP_EOL .
            '<!-- page: ' . $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'] . ' -->'    . PHP_EOL .
            '<!-- file: ' . basename( FILE_CACHE_PAGE ) . ' -->'                . PHP_EOL;
            header( 'Content-type: text/html; charset=utf8' );
            die( file_get_contents( FILE_CACHE_PAGE ) . $cacheinfo );
        }

    }

    // debug
    // echo 'OUTPUT';
