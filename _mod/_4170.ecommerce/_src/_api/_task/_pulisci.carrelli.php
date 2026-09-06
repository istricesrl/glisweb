<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
    }

    /**
     * Ripulisce i carrelli rimasti vuoti.
     *
     * Ogni visitatore che apre la pagina del carrello ne fa nascere uno a database, quindi senza
     * questa pulizia la tabella cresce di righe che non sono mai diventate un ordine.
     *
     * Due cautele, imparate sul campo:
     *
     * - un carrello che ha raggiunto il checkout o il pagamento non si cancella mai, nemmeno se i
     *   campi anagrafici risultano vuoti. E' la traccia di un ordine reale, ci si risale dal
     *   gestionale, e cancellarla lascia l'ordine senza corrispettivo sul sito;
     * - la cancellazione viene contata e scritta a log. Prima era muta, e quando un carrello
     *   spariva non restava alcun modo di sapere se fosse stato questo task o altro: senza il
     *   conteggio la diagnosi si riduce a congetture.
     */
    $carrelliDaPulire = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT count( id ) FROM carrelli WHERE coalesce(
            destinatario_nome,
            destinatario_cognome,
            destinatario_denominazione,
            intestazione_nome,
            intestazione_cognome,
            intestazione_denominazione
        ) IS NULL
        AND timestamp_checkout IS NULL
        AND timestamp_pagamento IS NULL
        AND (
            timestamp_inserimento IS NULL
            OR
            timestamp_inserimento < unix_timestamp( now( ) ) - 3600
        )'
    );

    mysqlQuery(
        $cf['mysql']['connection'],
        'DELETE FROM carrelli WHERE coalesce(
            destinatario_nome,
            destinatario_cognome,
            destinatario_denominazione,
            intestazione_nome,
            intestazione_cognome,
            intestazione_denominazione
        ) IS NULL
        AND timestamp_checkout IS NULL
        AND timestamp_pagamento IS NULL
        AND (
            timestamp_inserimento IS NULL
            OR
            timestamp_inserimento < unix_timestamp( now( ) ) - 3600
        )'
    );

    logWrite( 'pulizia dei carrelli vuoti: ' . intval( $carrelliDaPulire ) . ' righe cancellate', 'cart', LOG_ERR );

    buildJson( array( 'status' => 'ok', 'cancellati' => intval( $carrelliDaPulire ) ) );
