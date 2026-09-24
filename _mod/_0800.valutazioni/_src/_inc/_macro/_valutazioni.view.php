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
    $ct['view']['table'] = 'valutazioni';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'valutazioni.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'timestamp_valutazione' => 'data',
        'anagrafica' => 'esecutore',
        'matricola' => 'matricola',
        'immobile' => 'immobile',
        'condizione' => 'condizione',
	    'disponibilita' => 'disponibilità'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap',
        'timestamp_valutazione' => 'text-left no-wrap',
        'anagrafica' => 'text-left no-wrap',
        'matricola' => 'text-left',
        'immobile' => 'text-left',
        'condizione' => 'text-left no-wrap',
	    'disponibilita' => 'text-left'
	);
    
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( isset($ct['view']['data']) ){
        foreach( $ct['view']['data'] as &$row ) {
            if( is_array( $row ) ) {
                if( !empty($row['timestamp_valutazione']) ){
                    $row['timestamp_valutazione'] = date('d/m/Y H:s', $row['timestamp_valutazione']);
                }
            }
        }
    }