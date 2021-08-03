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
    $ct['form']['table'] = 'articoli';
    
    $ct['view']['table'] = '__report_mastri__';

    $ct['view']['data']['__report_mode__'] = 1;

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.articoli.form';
    $ct['view']['open']['table'] = 'documenti_articoli';
    $ct['view']['open']['field'] = 'id_riga';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'mastro' => 'mastro',
        'data_lavorazione' => 'data',
	    'descrizione' => 'riga',
        'id_articolo' => 'articolo',
        'quantita' => 'quantità',
        'importo' => 'importo',
        'id_listino' => 'id_listino',
        'id_riga' => 'id_riga',
        'cliente' => 'cliente',
        'id_tipologia' => 'id_tipologia',
        'id_todo' => 'todo',
        'progetto' => 'progetto',
        'matricola' => 'matricola'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none',
        'id_attivita' => 'd-none',
        'id_todo' => 'd-none',
        'id_cliente' => 'd-none',
        'id_tipologia' => 'd-none',
        'id_articolo' => 'd-none',
        'data' => 'text-left',
	    'nome_attivita' => 'text-left',
        'id_progetto' => 'd-none',
        'importo' => 'text-right',
        'quantita' => 'text-right',
        'cliente' => 'text-left',
        'mastro' => 'text-left'

	);

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_articolo']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
