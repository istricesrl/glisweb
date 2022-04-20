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
    $ct['form']['table'] = 'contratti';
    
    // tabella della vista
	$ct['view']['table'] = '';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'id_contratto' => 'id_contratto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
        'id_contratto' => 'no-wrap'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'immobili.form';
    $ct['view']['open']['table'] = 'edifici';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'immobili.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_contratto';
	$ct['view']['open']['preset']['subform'] = '';

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_contratto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';