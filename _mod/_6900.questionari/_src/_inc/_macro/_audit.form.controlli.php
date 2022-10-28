<?php

    /**
     * macro form controlli
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'audit';


    // tabella della vista
	$ct['view']['table'] = 'controlli';

        // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'controlli.form';
    $ct['view']['open']['table'] = 'controlli';
    $ct['view']['open']['field'] = 'id';

	// pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'controlli.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_audit';

	$ct['view']['cols'] = array(
        'id' => '#',
        'progetto' => 'progetto',
		'anagrafica' => 'anagrafica',
		'tipologia_questionario' => 'tipologia',
		'questionario' => 'questionario'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'progetto' => 'text-left',
        'anagrafica' => 'text-left',
        'tipologia_questionario' => 'text-left',
		'questionario' => 'text-left'
    );

	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
		// preset filtro custom progetti aperti
		$ct['view']['__restrict__']['id_audit']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	}

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

