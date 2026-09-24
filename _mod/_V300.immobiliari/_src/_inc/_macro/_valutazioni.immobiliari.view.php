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
	$ct['view']['open']['page'] = 'valutazioni.immobiliari.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'timestamp_valutazione' => 'data',
        'anagrafica' => 'esecutore',
        'immobile' => 'immobile',
        'condizione' => 'condizione',
	    'disponibilita' => 'disponibilità',
        'mq_calpestabili' => 'mq calpestabili',
	    'mq_commerciali' => 'mq commerciali',
        'classe_energetica' => 'classe energetica'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'timestamp_valutazione' => 'no-wrap',
	    '__label__' => 'text-left no-wrap'
	);
    
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( isset($ct['view']['data']) ){
        foreach( $ct['view']['data'] as &$row ) {
            if( !empty($row['timestamp_valutazione']) ){
                $row['timestamp_valutazione'] = date('d/m/Y H:s', $row['timestamp_valutazione']);
            }
        }
    }