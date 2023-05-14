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
	$ct['view']['table'] = 'contratti_anagrafica';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'id_contratto' => '#',
        'id_anagrafica' => 'anagrafica',
        'progetto' => 'corso',
        'tipologia' => 'tipologia',
        'data_inizio' => 'inizio',
        'data_fine' => 'fine'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'id_contratto' => 'd-none',
        'id_anagrafica' => 'd-none',
        'codice' => 'text-left d-none d-md-table-cell',
        'tipologia' => 'text-left',
        'data_inizio' => 'text-left',
        'data_fine' => 'text-left'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'iscrizioni.form';
    $ct['view']['open']['table'] = 'contratti';
    $ct['view']['open']['field'] = 'id_contratto';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'iscrizioni.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_anagrafica';

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        
        // preset filtro custom progetti aperti
        $ct['view']['__restrict__']['id_anagrafica']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
        $ct['view']['__restrict__']['se_iscrizione']['EQ'] = 1;

    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
