<?php

/**
     * macro form articoli
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
    $ct['form']['table'] = 'sconti';

    // tabella della vista
	$ct['view']['table'] = 'sconti_articoli';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
	    'id_sconto' => 'ID sconto',
	    'id_articolo' => 'ID articolo',
        'articolo' => 'descrizione'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left',
        'id' => 'd-none',
        'id_sconto' => 'd-none', 
        'valuta_utf8' => 'd-none', 
        'prezzo' => 'text-right',
        'articolo' => 'text-left',
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'sconti.articoli.form';
    $ct['view']['open']['table'] = 'sconti_articoli';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'sconti.articoli.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_sconto';

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_sconto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // inserimento rapido
	$ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/sconti.form.articoli.insert.html',
        'fa' => 'fa-plus-circle'
    );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
