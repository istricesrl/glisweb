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
	$ct['view']['table'] = 'fasce';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'fasce.form';
    $ct['view']['open']['table'] = 'categorie_progetti';

     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        '__label__' => 'fascia di età'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
        '__label__' => 'text-left'
	);
   
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
