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


    // tabella della vista
	$ct['view']['table'] = '__report_giacenza_mastri__';
    $ct['view']['data']['__report_mode__'] = 1;

    // id della vista
    $ct['view']['id'] = md5( $ct['view']['table'] );

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'id_articolo' => 'articolo',
        'quantita_totale' => 'quantità',
        'importo_totale' => 'importo'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
        'id_riga' => 'd-none',
	    'descrizione' => 'text-left',
        'importo' => 'text-right'
	);

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
  
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	///foreach( $ct['view']['data'] as &$row ) {
	//}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
