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
	    'id_prodotto' => 'prodotto',
        'id' => 'articolo',
	    'nome' => 'nome',
        'ean' => 'EAN'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'nome' => 'text-left',
	    'ean' => 'text-left'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
