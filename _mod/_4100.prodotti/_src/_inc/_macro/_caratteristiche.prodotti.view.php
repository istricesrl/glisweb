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
	$ct['view']['table'] = 'caratteristiche';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'caratteristiche.prodotti.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'nome'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
