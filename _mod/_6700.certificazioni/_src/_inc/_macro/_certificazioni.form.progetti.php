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
	$ct['view']['table'] = 'progetti_certificazioni';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'progetti.produzione.form';

    $ct['view']['open']['table'] = 'progetti';

    #print_r( $ct['view'] );

    // campo per l'id di apertura
	$ct['view']['open']['field'] = 'id_progetto';

    $ct['view']['cols'] = array(
	    'id' => '#',
        'id_progetto' => 'id progetto',
        'progetto' => 'progetto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'progetto' => 'text-left no-wrap'
	);

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_certificazione']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }


    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
