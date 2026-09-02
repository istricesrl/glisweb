<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
    $ct['view']['data']['__report_mode__'] = 1;
    $ct['view']['table'] = '__report_documenti_carrelli__';

    // tabella per la gestione degli oggetti esistenti
	// $ct['view']['open']['table'] = 'progetti';

    // pagina per la gestione degli oggetti esistenti
	// $ct['view']['open']['page'] = 'corsi.form';

    // id della vista
    // $ct['view']['id'] = md5( $ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__'] );

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'anagrafica' => 'cliente',
        'tipologia_contratto' => 'acquisto',
        'prezzo_lordo_finale' => 'totale dovuto',
        'pagato' => 'totale pagato',
        'rateizzato' => 'totale rateizzato',
        // 'scaduto' => 'totale scaduto',
        'sospeso' => 'totale in sospeso',
        'data_acquisto' => 'data acquisto',
        NULL => 'azioni'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none',
        'anagrafica' => 'text-left d-none d-md-table-cell',
        'pagato' => 'text-right',
        'rateizzato' => 'text-right',
        'scaduto' => 'text-right',
        'sospeso' => 'text-right',
        NULL => 'nowrap'
    );

    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    /**
     * Fix 2026-09-01: si formattano solo le colonne che la vista ha davvero selezionato.
     *
     * `scaduto` e' commentata fra le `cols` qui sopra, quindi la query della vista non la
     * restituisce: `$row['scaduto']` non esiste e in PHP 8 ogni riga produceva un
     * `Notice: Undefined index: scaduto` stampato dentro la tabella dello scadenziario.
     *
     * Il ciclo scriveva anche la chiave mancante, aggiungendo a ogni riga una colonna vuota che
     * la vista non sa rendere. Ciclare sull'elenco e saltare le chiavi assenti rende il blocco
     * indifferente a quali colonne siano attive: commentarne una in `cols` non richiede piu' di
     * ricordarsi di commentarla anche qui.
     */
    $importi = array( 'pagato', 'rateizzato', 'scaduto', 'sospeso' );

	foreach( $ct['view']['data'] as &$row ) {
		if( is_array( $row ) ) {

            foreach( $importi as $importo ) {
                if( array_key_exists( $importo, $row ) ) {
                    $row[ $importo ] = writeCurrency( $row[ $importo ] );
                }
            }

        }
    }
