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
    $ct['form']['table'] = 'mastri';
    $ct['view']['data']['__report_mode__'] = 1;

    // tabella della vista
    $ct['view']['table'] = '__report_giacenza_magazzini__';

    // pagina per la gestione degli oggetti esistenti
    $ct['view']['open']['page'] = 'articoli.form';
    $ct['view']['open']['table'] = 'articoli';
    $ct['view']['open']['field'] = 'id_articolo'; 

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'id_articolo' => 'codice',
        'articolo' => 'descrizione',
        'matricola' => 'matricola',
        'carico' => 'carico',
        'scarico' => 'scarico',
        'totale' => 'totale'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'articolo' => 'text-left',
        'totale' => 'text-right'
    );

    // preset filtro custom mastro corrente
	$ct['view']['__restrict__']['id']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
  
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	///foreach( $ct['view']['data'] as &$row ) {
	//}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';