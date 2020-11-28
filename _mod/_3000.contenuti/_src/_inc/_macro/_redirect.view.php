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
        'codice' => 'HTTP',
        'sorgente' => 'sorgente'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'codice' => 'text-left no-wrap',
        'sorgente' => 'text-left no-wrap'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
