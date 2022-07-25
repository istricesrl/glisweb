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
	$ct['view']['table'] = 'iscrizioni';


    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'emittente' => 'emittente',
        'destinatario' => 'destinatario',
        'progetto' => 'progetto',
        'tipologia' => 'tipologia',
	    '__label__' => 'contratto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'text-left',
	    '__label__' => 'text-left',
        'id_prodotto' => 'd-none'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'contratti.form';
    $ct['view']['open']['table'] = 'contratti';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
	//$ct['view']['insert']['page'] = 'contratti.form';

    //$_SESSION['__work__']['id_anagrafica'] 

    $ct['view']['insert']['page'] = 'corsi.view';

    // campi della vista
	$ct['view']['insert']['options'] = array(
        array( 'name' => '__work__[id_anagrafica]', 'value' => $_REQUEST[  $ct['form']['table'] ]['id'] )
	);

        // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_destinatario';

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_destinatario']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
