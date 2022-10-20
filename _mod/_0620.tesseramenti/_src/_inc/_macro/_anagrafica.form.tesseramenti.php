<?php

    /**
     *
     *
     *
     * @todo documentare
     * 
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'anagrafica';
    
    // tabella della vista
	$ct['view']['table'] = '__report_tesseramenti_anagrafica__';
    $ct['view']['data']['__report_mode__'] = 1;

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'id_anagrafica' => 'anagrafica',
        'se_tesseramento' => 'tesseramento',
#        'codice' => 'numero tessera',
        'id_contratto' => 'numero contratto',
        'tipologia' => 'tipologia',
        'data_inizio' => 'inizio',
        'data_fine' => 'fine'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
        'id_anagrafica' => 'd-none',
        'se_tesseramento' => 'd-none',
#        'codice' => 'text-left d-none d-md-table-cell',
        'id_contratto' => 'd-none',
        'tipologia' => 'text-left',
        'data_inizio' => 'text-left',
        'data_fine' => 'text-left'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'tesseramenti.form';
    $ct['view']['open']['table'] = 'contratti';
    $ct['view']['open']['field'] = 'id_contratto';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'tesseramenti.form';

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        
        // preset filtro custom progetti aperti
        $ct['view']['__restrict__']['id_anagrafica']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
        $ct['view']['__restrict__']['se_tesseramento']['EQ'] = 1;

    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
