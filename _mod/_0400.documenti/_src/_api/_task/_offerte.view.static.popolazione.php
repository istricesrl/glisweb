<?php

    /**
     * popolazione della vista statica offerte_view_static
     *
     * Wrapper su syncStaticView() ( _src/_lib/_mysql.tools.php ), che fa il lavoro vero: cerca fino a un lotto
     * di righe rimaste indietro ( mancanti nella statica, o con i timestamp NULL o piu' vecchi della tabella
     * base ) e le rigenera. E' nato il 04/10/2026 con la corte di task della statica, nella stessa forma degli
     * altri task di popolazione.
     *
     * offerte_view_static non ha una tabella omonima: nasce da documenti, e la condizione sulla tipologia dice
     * quali documenti sono offerte. La stessa coppia tabella/condizione la usa il task di pulizia.
     *
     * Chiamata standard: /task/0400.documenti/offerte.view.static.popolazione
     * Chiamata forzata, che riscrive una riga sola: /task/0400.documenti/offerte.view.static.popolazione?idDocumento=<id>
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
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_MYSQL' );

    // inizializzo l'array del risultato
    $status = array();

    // ...
    if( ! isset( $_REQUEST['idDocumento'] ) ) {

        // riallineo un lotto di righe rimaste indietro
        $status['riallineate'] = syncStaticView( $cf['mysql']['connection'], 'offerte', 100, array(), 'documenti', 'documenti.id_tipologia IN ( SELECT id FROM tipologie_documenti WHERE se_offerta IS NOT NULL )' );
        $status['modalita'] = 'standard';

        // metroLoopWs() ripete la chiamata finche' aggiornare.id non e' vuoto
        $status['aggiornare']['id'] = ( ! empty( $status['riallineate'] ) ) ? $status['riallineate'] : NULL;

    } else {

        // riscrivo la riga indicata
        $status['aggiornare']['id'] = $_REQUEST['idDocumento'];
        $status['modalita'] = 'forzata';
        $status['done'] = true;

        // la riga vecchia si toglie prima, perche' un documento puo' USCIRE dalla vista restando in
        // archivio ( tipologia cambiata ) e la REPLACE non se ne accorgerebbe: e' la stessa ragione del
        // controller finally
        mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM offerte_view_static WHERE id = ?', array( array( 's' => $status['aggiornare']['id'] ) ) );
        refreshStaticView( $cf['mysql']['connection'], 'offerte', $status['aggiornare']['id'] );

    }

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
