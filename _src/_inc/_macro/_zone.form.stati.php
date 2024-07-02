<?php

    /**
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'zone';
    
    // tabella della vista
	$ct['view']['table'] = 'zone_stati';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'zone.stati.form';

	// pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'zone.stati.form';
	$ct['view']['insert']['field'] = 'id_zona';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_zona';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
//	    '__label__' => 'contatto',
//	    'telefoni' => 'telefoni',
//	    'mail' => 'mail',
//	    'categorie' => 'categorie'
		'stato' => 'stato',
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
//	    '__label__' => 'text-left no-wrap',
//	    'telefoni' => 'text-left',
//	    'mail' => 'text-left',
//	    'categorie' => 'text-left d-none d-md-block'
	);

	$ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/zone.form.stati.insert.html',
        'fa' => 'fa-plus-circle'
    );

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_zona']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
