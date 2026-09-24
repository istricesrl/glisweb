<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
    }

    /**
     * Fix 2026-09-09: rimesso il controllo dei privilegi.
     *
     * File ricostruito unendo due versioni che si erano sovrascritte a vicenda upstream il
     * 06/09/2026 alle 21:29: il riallineamento da GIMBE portava le due condizioni di sicurezza
     * sulla DELETE ( vedi sotto ) ma partiva da una copia precedente al 05/09, quindi senza il
     * controllo dei privilegi; il riallineamento da Masi, subito dopo, rimetteva il controllo ma
     * riportava la DELETE alla versione senza guardie.
     *
     * La versione senza guardie non e' un dettaglio di stile: al 09/09/2026, sul solo database di
     * produzione della Polisportiva Masi, avrebbe cancellato 1.284 carrelli, di cui 1.281 con un
     * checkout o un pagamento e 1.166 gia' PAGATI. E siccome `carrelli_articoli.id_carrello` e
     * `pagamenti.id_carrelli_articoli` sono tutt'e due ON DELETE CASCADE, con i carrelli sarebbero
     * spariti anche le righe e i pagamenti incassati.
     */
    checkTaskPrivilege( 'GESTIONE_ECOMMERCE' );

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
