<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */
    
    // tabella della vista
	$ct['view']['table'] = 'coupon';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'coupon.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => 'codice',
        'nome' => 'nome',
        'anagrafica' => 'nominativo',
	    'sconto_percentuale' => 'percentuale',
	    'sconto_fisso' => 'importo'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'nome' => 'text-left',
        'anagrafica' => 'text-left',
        'sconto_percentuale' => 'text-right',
        'sconto_fisso' => 'text-right'
	);

	// preset ordinamento
    $ct['view']['__sort__'] = array(
        'id' => 'ASC'
    );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
