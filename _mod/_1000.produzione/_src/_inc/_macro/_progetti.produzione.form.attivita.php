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
	$ct['view']['table'] = 'attivita';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';

    $ct['view']['cols'] = array(
		'id' => '#',
        'data_attivita' => 'data',
        'anagrafica' => 'persona',
        'nome' => 'attivita',
        'ore' => 'ore',
        '__label__' => 'tipologia'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'anagrafica' => 'text-left',
	    'nome' => 'text-left',
	    'priorita' => 'text-left',
	);
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'attivita.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_progetto';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_progetto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
