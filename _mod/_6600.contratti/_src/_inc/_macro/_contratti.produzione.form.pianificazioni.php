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
    $ct['form']['table'] = 'contratti';
    
    // tabella della vista
	$ct['view']['table'] = 'cron';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'cron.form';

    //campi della vista
    $ct['view']['cols'] =  array(
        'id' => '#',
        'nome' => 'nome',
        'token' => 'token',
        'delay' => 'delay',
        'task' => 'task'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'nome' => 'text-left',
        'token' => 'text-right',
        'delay' => 'text-right'
    );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'cron.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'cron.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_contratto';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_contratto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }


        // macro di default per l'entità contratti
	require '_contratti.form.default.php';

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
