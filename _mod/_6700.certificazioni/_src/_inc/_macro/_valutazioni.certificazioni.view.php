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
    $ct['view']['table'] = 'valutazioni_certificazioni';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'valutazioni.certificazioni.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
//        'valutazione' => 'valut',
#        'certificazione' => 'certificazione',
#        'emittente' => 'emittente',
        'data_emissione' => 'data emissione',
        'data_scadenza' => 'data scadenza'
    );

    // stili della vista
	$ct['view']['class'] = array(
	    'anagrafica' => 'text-left',
        'certificazione' => 'text-left',
        'emittente' => 'text-left'
	);

    // inclusione filtri speciali
#	$ct['etc']['include']['filters'] = 'inc/anagrafica.certificazioni.view.filters.html';

    
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
