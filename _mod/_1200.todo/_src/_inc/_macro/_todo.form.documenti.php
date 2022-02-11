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
    $ct['form']['table'] = 'todo';
    
    // tabella della vista
	$ct['view']['table'] = 'documenti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.form';

     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'data' => 'data',
	    '__label__' => 'documento'
    );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
        'data' => 'no-wrap', 
	    '__label__' => 'text-left no-wrap'
    );
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'documenti.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_todo';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_todo']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }
    
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
