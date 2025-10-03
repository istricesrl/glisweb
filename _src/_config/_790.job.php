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
    $cf['jobs']['foreground'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT * FROM job WHERE se_foreground = 1 '.
        'AND ( id_account_inserimento = ? OR id_account_inserimento IS NULL ) '.
        'AND timestamp_completamento IS NULL',
        array(
            array( 's' => isset( $cf['session']['account']['id'] )  ? $cf['session']['account']['id'] : NULL )
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

