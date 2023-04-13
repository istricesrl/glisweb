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
    $ct['form']['table'] = 'certificazioni';
    
    // tabella della vista
	$ct['view']['table'] = 'anagrafica_certificazioni';

    $ct['view']['cols'] = array(
	    'id' => '#',
        'anagrafica' => 'anagrafica',
        'emittente' => 'emittente',
        'data_emissione' => 'data emissione',
        'data_scadenza' => 'data scadenza'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'anagrafica' => 'text-left no-wrap',
	    'emittente' => 'text-left'
	);
    
    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_certificazione';


    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
