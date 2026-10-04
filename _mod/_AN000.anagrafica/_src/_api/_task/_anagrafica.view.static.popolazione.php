<?php

    /**
     * popolazione della vista statica anagrafica_view_static
     *
     * Wrapper su syncStaticView() ( _src/_lib/_mysql.tools.php ), che fa il lavoro vero: cerca fino a un lotto
     * di righe rimaste indietro ( mancanti nella statica, o con i timestamp NULL o piu' vecchi della tabella
     * base ) e le rigenera. Il nome e il percorso restano quelli di sempre, perche' le pianificazioni dei deploy
     * e i pulsanti degli strumenti lo chiamano cosi'.
     *
     * Le correlate sono le stesse del task di prima: anagrafica_categorie, perche' la vista porta le categorie.
     *
     * Gemello di _src/_api/_task/_anagrafica.view.static.popolazione.php.
     *
     * Chiamata standard: /task/AN000.anagrafica/anagrafica.view.static.popolazione
     * Chiamata forzata, che riscrive una riga sola: /task/AN000.anagrafica/anagrafica.view.static.popolazione?id=<id>
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
        $status['riallineate'] = syncStaticView( $cf['mysql']['connection'], 'anagrafica', 100, array( 'anagrafica_categorie' ) );
        $status['modalita'] = 'standard';

        // metroLoopWs() ripete la chiamata finche' aggiornare.id non e' vuoto
        $status['aggiornare']['id'] = ( ! empty( $status['riallineate'] ) ) ? $status['riallineate'] : NULL;

    } else {

        // riscrivo la riga indicata
        $status['aggiornare']['id'] = $_REQUEST['id'];
        $status['modalita'] = 'forzata';
        $status['done'] = true;
        updateAnagraficaViewStatic( $status['aggiornare']['id'] );

    }

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
