<?php

    /**
     * pulizia della vista statica documenti_view_static
     *
     * Toglie dalla statica le righe dei documenti che non esistono piu': syncStaticView() le righe le aggiunge e le
     * riscrive ma non le toglie, e il controller finally toglie solo quelle cancellate passando dal controller. Con
     * cleanStaticView() ( _src/_lib/_mysql.tools.php ), adatto a un giro poco frequente.
     *
     * Chiamata: /task/documenti.view.static.pulizia
     *
     * @file
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_MYSQL' );

    // inizializzo l'array del risultato
    $status = array();

    // ...
    $status['esito'] = cleanStaticView( $cf['mysql']['connection'], 'documenti' );

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
