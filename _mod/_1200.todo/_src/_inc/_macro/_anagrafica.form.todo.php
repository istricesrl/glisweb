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
    $ct['form']['table'] = 'anagrafica';
    
    // tabella della vista
	$ct['view']['table'] = 'todo';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'todo.form';

    $ct['view']['cols'] = array(
	    'id' => '#',
#	    'data_programmazione' => 'pianificato',
#	    'priorita' => 'priorità',
		'codice' => 'codice',
		'id_cliente' => 'ID tipologia',
		'tipologia' => 'tipologia',
	    'nome' => 'titolo',
#	    'anagrafica' => 'assegnato a',
#		'settimana_programmazione' => 'settimana',
#		'anno_programmazione' => 'anno'
#	    'progresso' => 'ore',
#	    'completato' => 'stato',
#	    'id_priorita' => 'id_priorita'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'id_priorita' => 'd-none',
	    'id_cliente' => 'd-none',
#		'completato' => 'd-none',
	    'cliente' => 'text-left d-none d-md-table-cell',
	    'nome' => 'text-left',
	    'priorita' => 'text-left',
	    'anagrafica' => 'text-left no-wrap d-none d-sm-table-cell',
	    'progresso' => 'text-right no-wrap d-none d-sm-table-cell',
#	    'completato' => 'text-left'
	);
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'todo.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'todo.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_cliente';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ) {
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_cliente']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

	// gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
/*
	// preset ordinamento
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['anno_programmazione'] = 'ASC';
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['settimana_programmazione'] = 'ASC';
    }
*/

    // macro di default
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';
	require DIR_SRC_INC_MACRO . '_default.form.php';
