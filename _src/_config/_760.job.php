<?php

    /**
     * gestione dei job in foreground
     * 
     * 
     *
     * @todo finire la documentazione
     *
     * @file
     *
     */

    // seleziono i job a cui ho applicato il lock
    $cf['jobs']['foreground'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT * FROM job WHERE se_foreground IS NOT NULL '.
        'AND ( id_account_inserimento = ? OR id_account_inserimento IS NULL ) '.
        'AND timestamp_completamento IS NULL',
        array(
            array( 's' => isset( $cf['session']['account']['id'] )  ? $cf['session']['account']['id'] : NULL )
        )
    );

    // debug
        // print_r( $cf['jobs']['foreground'] );

    // collegamento a $ct
	$ct['jobs']['foreground']				                        = &$cf['jobs']['foreground'];
