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
	$ct['view']['table'] = 'contratti_produzione';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'contratti.produzione.form';

     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'tipologia' => 'tipologia',
        '__label__' => 'nome'
    );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
        'tipologia' => 'text-left',
        '__label__' => 'text-left'
    );
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'contratti.produzione.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'contratti.produzione.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_progetto';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom sul progetto corrente
	    $ct['view']['__restrict__']['id_progetto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
