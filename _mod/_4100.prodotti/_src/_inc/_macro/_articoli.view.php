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
	$ct['view']['table'] = 'articoli';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'articoli.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
	    'nome' => 'nome',
        'ean' => 'EAN',
	    'id_prodotto' => 'prodotto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'text-left',
	    'nome' => 'text-left',
	    'ean' => 'text-left',
        'id_prodotto' => 'text-left'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
