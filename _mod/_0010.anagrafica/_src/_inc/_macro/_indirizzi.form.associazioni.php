<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'indirizzi';

    // tabella della vista
    $ct['view']['table'] = 'anagrafica_indirizzi';
    
    // pagina per la gestione degli oggetti esistenti
    $ct['view']['open']['page'] = 'anagrafica.form';
    $ct['view']['open']['table'] = 'anagrafica';
    $ct['view']['open']['field'] = 'id_anagrafica';

     // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'anagrafica' => 'anagrafica',
        'id_anagrafica' => 'ID anagrafica',
	    'interno' => 'interno',
	    'descrizione' => 'descrizione'
    );
    
    // stili della vista
	$ct['view']['class'] = array(
        'anagrafica' => 'text-left',
        'id_anagrafica' => 'd-none',
	    'interno' => 'text-left',
	    'descrizione' => 'text-left'
    );

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_indirizzo']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
