<?php

    /**
     * macro form prodotti prezzi
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'listini';

    // tabella della vista
	$ct['view']['table'] = 'prezzi';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'id_prodotto' => 'prodotto',
	    'id_articolo' => 'articolo',
        'fascia' => 'fascia',
        'qta_min' => 'q.tà min.',
        'qta_max' => 'q.tà max.',
        'prezzo' => 'prezzo',
        'iso4217' => 'valuta',
        'iva' => 'iva'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'text-left',
	    'iva' => 'text-left',
        'prezzo' => 'text-right',
//        'id_prodotto' => 'd-none'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'prezzi.form';
    $ct['view']['open']['table'] = 'prezzi';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'prezzi.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_listino';

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_listino']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
