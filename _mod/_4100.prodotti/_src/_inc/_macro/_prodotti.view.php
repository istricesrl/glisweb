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
	$ct['view']['table'] = 'prodotti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'prodotti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => 'prodotto',
        'nome' => 'nome',
	    'codice_produttore' => 'codice produttore',
	    'categorie' => 'categorie'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'codice_produttore' => 'text-left',
	    'categorie' => 'text-left',
	    'nome' => 'text-left'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
