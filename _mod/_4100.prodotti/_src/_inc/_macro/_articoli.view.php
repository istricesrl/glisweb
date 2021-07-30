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
	    'nome_articolo' => 'nome',
        'codice_produttore' => 'ean',
	    'id_prodotto' => 'prodotto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'nome_articolo' => 'text-left',
	    'id' => 'text-left',
	    'codice_produttore' => 'text-left',
        'id_prodotto' => 'text-left'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
