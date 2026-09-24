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
    $ct['form']['table'] = 'progetti';
    
    // tabella della vista
	$ct['view']['table'] = 'mastri';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'mastri.form';

    $ct['view']['cols'] = array(
		'id' => '#',
        'tipologia' => 'tipologia',
        'nome' => 'attivita'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'nome' => 'text-left'
	);
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'mastri.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'mastri.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_progetto';

    // preset filtro custom progetti aperti
    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
	    $ct['view']['__restrict__']['id_progetto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
