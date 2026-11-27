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
		// le date AAAA-MM-GG le ha gia' convertite in GG/MM/AAAA _default.view.php ( dal 2026-09-22 ), e
		// ripassarle da strtotime() leggeva GG/MM come MM/GG ( 01/01/1970 o giorno e mese scambiati ): si
		// riconverte solo quello che e' ancora AAAA-MM-GG, come un datetime che il default lascia com'e'
		foreach ( $ct['view']['data'] as &$row ){
             if(!empty($row['data_inizio'])){$row['data_inizio'] = ( preg_match( '/^[0-9]{4}-[0-9]{2}-[0-9]{2}/', $row['data_inizio'] ) ? date('d/m/Y', strtotime($row['data_inizio'])) : $row['data_inizio'] );}
          	}
	}