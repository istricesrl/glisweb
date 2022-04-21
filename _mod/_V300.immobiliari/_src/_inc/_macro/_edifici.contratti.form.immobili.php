<?php

    /**
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

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'id_immobile' => 'id_immobile'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
        'id_immobile' => 'no-wrap'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'edifici.form';
    $ct['view']['open']['table'] = 'edifici';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'edifici.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_immobile';
	$ct['view']['open']['preset']['subform'] = 'immobili';

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_immobile']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';