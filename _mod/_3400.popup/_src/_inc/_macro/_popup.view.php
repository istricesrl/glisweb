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
    $ct['view']['table'] = 'popup';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'popup.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        '__label__' => 'nome',
        'tipologia' => 'tipologia',
        'template' => 'template',
	    'schema_html' => 'schema'
	);

    // stili della vista
	$ct['view']['class'] = array(
        '__label__' => 'text-left no-wrap',
        'tipologia' => 'text-left',
        'template' => 'text-left',
	    'schema_html' => 'text-left'
    );
  
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
