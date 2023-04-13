<?php

    /**
     * macro form anagrafica
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
	$ct['form']['table'] = 'edifici';

    // tabella della vista
	$ct['view']['table'] = 'immobili';

    // id della vista
   	# $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'immobili.form';
    $ct['view']['open']['table'] = 'immobili';
    $ct['view']['open']['field'] = 'id';

	// pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'immobili.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_edificio';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'immobile',
        'contraenti' => 'contraenti',
        'proponenti' => 'proponenti',
        'id_edificio' => 'id_edificio'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap',
        'id_edificio' => 'd-none',
        'contraenti' => 'text-left',
        'proponenti' => 'text-left',
	);


	// preset filtro righe documento
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
		$ct['view']['__restrict__']['id_edificio']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	}

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';


