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
    $ct['view']['table'] = 'gruppi';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'gruppi.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'gruppo'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
