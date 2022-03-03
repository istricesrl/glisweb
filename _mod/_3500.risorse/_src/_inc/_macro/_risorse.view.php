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
    $ct['view']['table'] = 'risorse';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'risorse.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        '__label__' => 'nome',
        'tipologia' => 'tipologia',
        'codice' => 'codice',
        'testata' => 'testata'
	);

    // stili della vista
	$ct['view']['class'] = array(
        '__label__' => 'text-left no-wrap',
        'tipologia' => 'text-left',
        'codice' => 'text-left',
	    'testata' => 'text-left'
    );
  
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
