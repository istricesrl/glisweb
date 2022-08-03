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
    $ct['form']['table'] = 'categorie_anagrafica';
    
    // tabella della vista
	$ct['view']['table'] = 'anagrafica';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'anagrafica.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'contatto',
	    'telefoni' => 'telefoni',
	    'mail' => 'mail',
	    'categorie' => 'categorie'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left no-wrap',
	    'telefoni' => 'text-left',
	    'mail' => 'text-left',
	    'categorie' => 'text-left d-none d-md-block'
	);

    // colonne variabili
	if( isset( $_SESSION['account']['se_commerciale'] ) && ! empty( $_SESSION['account']['se_commerciale'] ) ) {
	    arrayInsertAssoc( '__label__', $ct['view']['cols'], array( 'provincia' => 'provincia' ) );
	    arrayInsertAssoc( '__label__', $ct['view']['class'], array( 'provincia' => 'text-left' ) );
	    $ct['view']['cols']['agente'] = 'agente';
	    $ct['view']['class']['agente'] = 'text-left';
	}

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['categorie']['LK'] = $_REQUEST[ $ct['form']['table'] ]['nome'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
