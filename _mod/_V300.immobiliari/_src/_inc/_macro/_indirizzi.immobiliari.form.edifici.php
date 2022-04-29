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
	$ct['form']['table'] = 'indirizzi';

    // tabella della vista
	$ct['view']['table'] = 'edifici';

    // id della vista
   	# $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'edifici.form';
    $ct['view']['open']['table'] = 'edifici';
    $ct['view']['open']['field'] = 'id';

	// pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'edifici.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_indirizzo';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'edificio',
        'piani' => 'piani',
        'id_indirizzo' => 'id_indirizzo'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap',
        'id_indirizzo' => 'd-none'
	);


	// preset filtro righe documento
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
		$ct['view']['__restrict__']['id_indirizzo']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	}

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';


