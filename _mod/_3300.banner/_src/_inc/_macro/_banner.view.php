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
    $ct['view']['table'] = 'banner';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'banner.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'nome' => 'nome',
        'tipologia' => 'tipologia'
	);

    // stili della vista
	$ct['view']['class'] = array(
        '__label__' => 'text-left no-wrap',
        'tipologia' => 'text-left'
    );
  
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
