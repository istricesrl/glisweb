<?php

    /**
     * popolazione della vista statica articoli_view_static
     *
     * Wrapper su syncStaticView() ( _src/_lib/_mysql.tools.php ), che fa il lavoro vero: cerca fino a un lotto
     * di righe rimaste indietro ( mancanti nella statica, o con i timestamp NULL o piu' vecchi della tabella
     * base ) e le rigenera. Il nome e il percorso restano quelli di sempre, perche' le pianificazioni dei deploy
     * e i pulsanti degli strumenti lo chiamano cosi'.
     *
     * Gemello di _mod/_PR000.prodotti/_src/_api/_task/_articoli.view.static.popolazione.php.
     *
     * Chiamata standard: /task/4100.prodotti/articoli.view.static.popolazione
     * Chiamata forzata, che riscrive una riga sola: /task/4100.prodotti/articoli.view.static.popolazione?idArticolo=<id>
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
    if( ! isset( $_REQUEST['idArticolo'] ) ) {

        // riallineo un lotto di righe rimaste indietro
        $status['riallineate'] = syncStaticView( $cf['mysql']['connection'], 'articoli' );
        $status['modalita'] = 'standard';

        // metroLoopWs() ripete la chiamata finche' aggiornare.id non e' vuoto
        $status['aggiornare']['id'] = ( ! empty( $status['riallineate'] ) ) ? $status['riallineate'] : NULL;

    } else {

        // riscrivo la riga indicata
        $status['aggiornare']['id'] = $_REQUEST['idArticolo'];
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
