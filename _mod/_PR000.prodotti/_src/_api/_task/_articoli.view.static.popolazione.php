<?php

    /**
     * popolazione della vista statica articoli_view_static
     *
     * Wrapper su syncStaticView() ( _src/_lib/_mysql.tools.php ), che fa il lavoro vero: cerca fino a un lotto
     * di righe rimaste indietro ( mancanti nella statica, o con i timestamp NULL o piu' vecchi della tabella
     * base ) e le rigenera. E' nato il 04/10/2026 con la corte di task della statica, nella stessa forma degli
     * altri task di popolazione.
     *
     * Gemello di _mod/_4100.prodotti/_src/_api/_task/_articoli.view.static.popolazione.php.
     *
     * Chiamata standard: /task/PR000.prodotti/articoli.view.static.popolazione
     * Chiamata forzata, che riscrive una riga sola: /task/PR000.prodotti/articoli.view.static.popolazione?id=<id>
     *
     * Fa parte della corte di task della statica: popolazione ( questo ), pulizia ( righe sparite dalla tabella
     * base ) e svuotamento ( solo per le emergenze ). Il ricalcolo completo non e' una pianificazione: a
     * tenere allineata la statica sono i controller e, come rete di sicurezza, questo task a lotti.
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
    if( ! isset( $_REQUEST['id'] ) ) {

        // riallineo un lotto di righe rimaste indietro
        $status['riallineate'] = syncStaticView( $cf['mysql']['connection'], 'articoli' );
        $status['modalita'] = 'standard';

        // metroLoopWs() ripete la chiamata finche' aggiornare.id non e' vuoto
        $status['aggiornare']['id'] = ( ! empty( $status['riallineate'] ) ) ? $status['riallineate'] : NULL;

    } else {

        // riscrivo la riga indicata
        $status['aggiornare']['id'] = $_REQUEST['id'];
        $status['modalita'] = 'forzata';
        $status['done'] = true;
        updateArticoliViewStatic( $status['aggiornare']['id'] );

    }

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
