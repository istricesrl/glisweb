<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

   // tabella della vista
    $ct['view']['table'] = 'redirect';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'redirect.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'id_sito' => 'sito',
        'codice_stato_http' => 'HTTP',
        'sorgente' => 'sorgente',
        'destinazione' => 'destinazione'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id_sito' => 'text-left no-wrap',
        'codice_stato_http' => 'text-left no-wrap',
        'sorgente' => 'text-left no-wrap',
        'destinazione' => 'text-left'
	);

    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/redirect.view.filters.html';

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {
            $row['id_sito'] = $cf['sites'][ $row['id_sito'] ]['__label__'];
        }
	}
