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
    $ct['form']['table'] = 'prodotti';
    
    // tabella della vista
	$ct['view']['table'] = 'articoli';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'nome' => 'articolo',
        'id_prodotto' => 'id_prodotto',
        'ean' => 'ean'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'text-left',
	    'nome' => 'text-left',
        'id_prodotto' => 'd-none'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'articoli.form';
    $ct['view']['open']['table'] = 'articoli';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'articoli.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_prodotto';

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_prodotto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
