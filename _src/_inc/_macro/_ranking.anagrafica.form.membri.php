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
    $ct['form']['table'] = 'ranking';
    
    // tabella della vista
	$ct['view']['table'] = 'anagrafica';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'anagrafica.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'contatto',
	    'telefoni' => 'telefoni',
	    'mail' => 'mail'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left no-wrap',
	    'telefoni' => 'text-left',
	    'mail' => 'text-left'
	);

    // colonne variabili
	if( isset( $_SESSION['account']['se_agente'] ) && ! empty( $_SESSION['account']['se_agente'] ) ) {
	    arrayInsertAssoc( '__label__', $ct['view']['cols'], array( 'provincia' => 'provincia' ) );
	    arrayInsertAssoc( '__label__', $ct['view']['class'], array( 'provincia' => 'text-left' ) );
	    $ct['view']['cols']['agente'] = 'agente';
	    $ct['view']['class']['agente'] = 'text-left';
	}

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_ranking']['LK'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
