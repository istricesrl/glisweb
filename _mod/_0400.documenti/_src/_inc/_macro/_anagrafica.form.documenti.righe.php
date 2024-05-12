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
    $ct['form']['table'] = 'anagrafica';
    
    // tabella della vista
    $ct['view']['table'] = 'documenti_articoli';
    
    // id della vista
   # $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.articoli.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data' => 'data',
        'documento' => 'documento',
        'tipologia' => 'tipologia',
        'emittente' => 'emittente',
        'destinatario' => 'destinatario',
        'nome' => 'nome',
        'id_articolo' => 'articolo',
        'quantita' => 'quantità',
#		'mastro_provenienza' => 'provenienza',
#		'mastro_destinazione' => 'destinazione',
        'importo_netto_totale' => 'importo'
    #    'totale_riga' => 'totale',
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none',
        'nome' => 'text-left',
        'id_articolo' => 'text-left',
        'importo_netto_totale' => 'text-right',
        'quantita' => 'text-right',     
        'totale_riga' => 'text-right',
        'cliente' => 'text-left',
        'emittente' => 'text-left', 
        'data' => 'no-wrap', 
        'tipologia' => 'text-left',
        'specifiche' => 'text-left',
        'documento' => 'text-left no-wrap'
    );

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_emittente|id_destinatario']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';
	require DIR_SRC_INC_MACRO . '_default.form.php';
