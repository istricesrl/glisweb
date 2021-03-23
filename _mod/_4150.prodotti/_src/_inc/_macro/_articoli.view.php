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
	    'id_prodotto' => 'prodotto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'nome' => 'text-left',
	    'categorie' => 'text-left',
	    'pubblicazione' => 'text-left'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
