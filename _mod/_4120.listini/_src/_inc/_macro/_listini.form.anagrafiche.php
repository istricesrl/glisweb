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
    $ct['form']['table'] = 'listini';

    // tabella della vista
	$ct['view']['table'] = 'listini_clienti';

    // pagina per la gestione degli oggetti esistenti
    $ct['view']['open']['page'] = 'listini.clienti.form';
    $ct['view']['open']['table'] = 'listini_clienti';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
    $ct['view']['insert']['page'] = 'listini.clienti.form';
    $ct['view']['insert']['field'] = 'id_listino';

    // campo per il preset di apertura
    // $ct['view']['open']['preset']['field'] = 'id_listino';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'cliente' => 'cliente'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none',
        'nome' => 'text-left',
        'quantita' => 'text-right',
		'totale_riga' => 'text-right',
        'id_documento' => 'd-none',
        'cliente' => 'text-left',
        'emittente' => 'text-left', 
        'data' => 'no-wrap', 
#        'tipologia' => 'text-left',
		'id_articolo' => 'text-left'
    );

#	$ct['etc']['include']['insert'] = 'inc/ddt.passivi.magazzini.form.righe.insert.html';

    // inserimento rapido
    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/listini.form.anagrafiche.insert.html',
        'fa' => 'fa-plus-circle'
    );

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
		// preset filtro custom progetti aperti
		$ct['view']['__restrict__']['id_listino']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	}

    // debug
    // echo 'DEBUG';

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // debug
    // echo 'DEBUG';

    // trasformazione icona attivo/inattivo
	///foreach( $ct['view']['data'] as &$row ) {
	//}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
