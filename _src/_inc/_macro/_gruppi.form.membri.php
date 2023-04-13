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
    $ct['form']['table'] = 'gruppi';
    
    // tabella della vista
	$ct['view']['table'] = 'account';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'account.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'account',
	    'utente' => 'anagrafica',
	    'se_attivo' => 'attivo'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left',
	    'utente' => 'text-left',
	    'se_attivo' => 'text-left'
	);

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_gruppi']['LK'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {
            if( $row['se_attivo'] == 1 ) { $row['se_attivo'] = '<i class="fa fa-check"></i>'; }
        }
	}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
