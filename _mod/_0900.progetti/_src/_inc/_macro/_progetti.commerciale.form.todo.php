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
	$ct['view']['table'] = 'todo';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'todo.form';

    $ct['view']['cols'] = array(
	    'id' => '#',
	    'pianificazione' => 'pianificato',
	    'priorita' => 'priorità',
	    'nome' => 'attività',
	    'responsabile' => 'assegnato a',
	    'progresso' => 'ore',
	    'completato' => 'stato',
	    'id_priorita' => 'id_priorita'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'id_priorita' => 'd-none',
	    'pianificazione' => 'text-left no-wrap',
	    'nome' => 'text-left',
	    'priorita' => 'text-left',
	    'responsabile' => 'text-left no-wrap d-none d-sm-table-cell',
	    'progresso' => 'text-right no-wrap d-none d-sm-table-cell',
	    'completato' => 'text-left'
	);
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'todo.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'todo.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_progetto';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_progetto']['LK'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
