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
	$ct['view']['table'] = '__report_mastri__';
    $ct['view']['data']['__report_mode__'] = 1;

    // id della vista
    $ct['view']['id'] = md5( $ct['view']['table'] );


    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.articoli.form';
    $ct['view']['open']['table'] = 'documenti_articoli';
    $ct['view']['open']['field'] = 'id_riga';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'data_lavorazione' => 'data',
	    'descrizione' => 'riga',
        'id_articolo' => 'articolo',
        'quantita' => 'quantità',
        'importo' => 'importo',
        'id_riga' => 'id_riga'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none',
        'id_riga' => 'd-none',
	    'descrizione' => 'text-left',
        'id_articolo' => 'text-left',
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
