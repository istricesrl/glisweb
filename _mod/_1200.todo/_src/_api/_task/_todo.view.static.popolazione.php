<?php

    /**
     * popolazione della vista statica todo_view_static
     *
     * Wrapper su syncStaticView() ( _src/_lib/_mysql.tools.php ), che fa il lavoro vero: cerca fino a un lotto
     * di righe rimaste indietro ( mancanti nella statica, o con i timestamp NULL o piu' vecchi della tabella
     * base ) e le rigenera. E' nato il 04/10/2026 con la corte di task della statica, nella stessa forma degli
     * altri task di popolazione.
     *
     * ATTENZIONE: todo_view_static non ha le colonne timestamp_inserimento e timestamp_aggiornamento, quindi
     * syncStaticView() riallinea solo le righe che mancano, non quelle cambiate.
     *
     * Chiamata standard: /task/1200.todo/todo.view.static.popolazione
     * Chiamata forzata, che riscrive una riga sola: /task/1200.todo/todo.view.static.popolazione?idTodo=<id>
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
    if( ! isset( $_REQUEST['idTodo'] ) ) {

        // riallineo un lotto di righe rimaste indietro
        $status['riallineate'] = syncStaticView( $cf['mysql']['connection'], 'todo' );
        $status['modalita'] = 'standard';

        // metroLoopWs() ripete la chiamata finche' aggiornare.id non e' vuoto
        $status['aggiornare']['id'] = ( ! empty( $status['riallineate'] ) ) ? $status['riallineate'] : NULL;

    } else {

        // riscrivo la riga indicata
        $status['aggiornare']['id'] = $_REQUEST['idTodo'];
        $status['modalita'] = 'forzata';
        $status['done'] = true;
        updateTodoViewStatic( $status['aggiornare']['id'] );

    }

    // debug
    // print_r( $_REQUEST );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
