<?php

    /**
     * recupero dei job in foreground
     * 
     * Questo file si occupa di selezionare i job in foreground e renderli disponibili per il template. Nel template athena
     * i job in foreground sono visualizzati assieme agli altri widget in /_src/_templates/_athena/inc/header.html.
     * 
     * 
     * 
     * TODO documentare
     * 
     */

    /**
     * recupero dei job in foreground
     * ==============================
     * 
     * 
     */

    // seleziono i job a cui ho applicato il lock
    //
    // Si prendono anche quelli chiusi da poco, non solo quelli ancora in corso. Il motivo e'
    // che il risultato di un job ( result.link, result.label ) e' proprio l'ultima cosa che
    // arriva: il driver in main.js lo mostra quando la risposta dice che il job e' chiuso.
    // Filtrando su timestamp_completamento IS NULL il job spariva dal riquadro al primo
    // ricaricamento della pagina, e chi non stava guardando lo schermo nel momento esatto in
    // cui la barra finiva non vedeva mai il link.
    //
    // L'ora e' la finestra piu' stretta che serve allo scopo: chi ha lanciato un lavoro torna
    // a cercarne l'esito entro pochi minuti, e oltre quella soglia il riquadro tornerebbe a
    // essere un elenco di roba vecchia.
    $cf['jobs']['foreground'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT * FROM job WHERE se_foreground = 1 '.
        'AND ( id_account_inserimento = ? OR id_account_inserimento IS NULL ) '.
        'AND ( timestamp_completamento IS NULL OR timestamp_completamento > ? )',
        array(
            array( 's' => isset( $cf['session']['account']['id'] )  ? $cf['session']['account']['id'] : NULL ),
            array( 's' => time() - 3600 )
        )
    );

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */
    
    // collegamento a $ct
    $ct['jobs']['foreground'] = &$cf['jobs']['foreground'];

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // print_r( $cf['jobs']['foreground'] );

