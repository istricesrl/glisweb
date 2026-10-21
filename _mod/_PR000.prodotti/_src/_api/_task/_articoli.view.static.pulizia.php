<?php

    /**
     * pulizia della vista statica articoli_view_static
     *
     * Toglie dalla statica le righe che non esistono piu' nella tabella base: syncStaticView() le righe le
     * riscrive ma non le cancella.
     *
     * Chiamata: /task/PR000.prodotti/articoli.view.static.pulizia
     *
     * @file
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../../../../_src/_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_MYSQL' );

    // inizializzo l'array del risultato
    $status = array();

    // ...
    $status['esito'] = cleanArticoliViewStatic();

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
