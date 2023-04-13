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
    $ct['form']['table'] = 'categorie_prodotti';
    
    // tabella della vista
	$ct['view']['table'] = 'prodotti_categorie';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
#	    'prodotto' => 'prodotto',
#        'id_categoria' => 'id_categoria',
        'id_prodotto' => 'id_prodotto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
#	    'prodotto' => 'text-left',
#	    'id_categoria' => 'd-none',
        'id_prodotto' => 'no-wrap'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'prodotti.form';
    $ct['view']['open']['table'] = 'prodotti';
    $ct['view']['open']['field'] = 'id_prodotto';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'prodotti.form';

        // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_categoria';
	$ct['view']['open']['preset']['subform'] = 'prodotti_categorie';

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_categoria']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
