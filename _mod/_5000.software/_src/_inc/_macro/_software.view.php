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
	$ct['view']['table'] = 'software';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'software.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
	    'nome' => 'nome',
        'articolo' => 'articolo'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'nome' => 'text-left',
	    'id' => 'text-left',
	    'articolo' => 'text-left'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
