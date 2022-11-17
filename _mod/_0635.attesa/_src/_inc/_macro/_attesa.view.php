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
	$ct['view']['table'] = 'attesa';

    // tabella per la gestione degli oggetti esistenti
    $ct['view']['open']['table'] = 'anagrafica_progetti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attesa.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
   //     'tipologia' => 'tipologia',
        'data_ora_inserimento' => 'aggiunto il',
        'anagrafica' => 'anagrafica',
        'progetto' => 'corso'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'anagrafica' => 'text-left',
        'progetto' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
             if(!empty($row['data_inizio'])){$row['data_inizio'] = date('d/m/Y', strtotime($row['data_inizio']));}
          	}
	}