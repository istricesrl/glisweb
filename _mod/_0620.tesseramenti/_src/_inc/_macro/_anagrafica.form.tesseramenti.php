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
    $ct['form']['table'] = 'anagrafica';
    
    // tabella della vista
	$ct['view']['table'] = 'tesseramenti';

/*
    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'articolo',
        'id_prodotto' => 'id_prodotto',
        'ean' => 'ean'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'text-left',
	    '__label__' => 'text-left',
        'id_prodotto' => 'd-none'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'tesseramenti.form';
    $ct['view']['open']['table'] = 'contratti';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'articoli.form';

        // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_prodotto';

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_prodotto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

*/

    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
