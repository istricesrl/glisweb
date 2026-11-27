<?php

    /**
     * svuotamento della vista statica documenti_view_static
     *
     * SOLO PER LE EMERGENZE: svuota la statica, che poi va ripopolata per intero con il task di popolazione
     * richiamato in ciclo. Finche' e' vuota getStaticViewExtension() fa leggere la vista, piu' lenta; mentre si
     * ripopola gli elenchi mostrano solo le righe gia' riscritte.
     *
     * Chiamata: /task/documenti.view.static.svuotamento
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
    if( ! empty( getStaticView( NULL, $cf['mysql']['connection'], 'documenti' ) ) ) {
        $status['esito'] = mysqlQuery( $cf['mysql']['connection'], 'TRUNCATE documenti_view_static' );
    } else {
        $status['esito'] = 'la statica non esiste su questo deploy';
    }

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
