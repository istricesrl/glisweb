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
        'codice' => 'codice',
        'tipologia' => 'categorie'
	);

    // stili della vista
	$ct['view']['class'] = array(
        '__label__' => 'text-left no-wrap',
        'codice' => 'text-left',
        'tipologia' => 'text-left'
    );
  
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
