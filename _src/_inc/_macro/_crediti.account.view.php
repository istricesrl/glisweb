<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella della vista
	$ct['view']['table'] = 'crediti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'crediti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data' => 'data movimento',
        'account_emittente' => 'emittente',
        'mastro_provenienza' => 'mastro provenienza',
        'account_destinatario' => 'destinatario',
        'mastro_destinazione' => 'mastro destinazione',
        'quantita' => 'quantita'
	);

	// stili della vista
	$ct['view']['class'] = array(
		'id' => 'd-none d-md-table-cell',
		'data' => 'text-left',
		'account_emittente' => 'text-left',
		'mastro_provenienza' => 'text-left',
		'account_destinatario' => 'text-left',
		'mastro_destinazione' => 'text-left',
		'quantita' => 'text-left',
	);

	#if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){

        // preset filtro account
        # $ct['view']['__restrict__']['id_progetto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    
	#}

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';	
