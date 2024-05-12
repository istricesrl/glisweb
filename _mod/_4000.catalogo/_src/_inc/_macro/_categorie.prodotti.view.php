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
	$ct['view']['table'] = 'categorie_prodotti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'categorie.prodotti.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'codice' => 'codice',
	    '__label__' => 'categoria'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none',
        'codice' => 'text-left',
	    '__label__' => 'text-left'
	);

	// preset ordinamento
    $ct['view']['__sort__'] = array(
        'codice' => 'ASC'
    );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
