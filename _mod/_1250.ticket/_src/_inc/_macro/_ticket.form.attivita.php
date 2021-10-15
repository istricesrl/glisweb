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
    $ct['form']['table'] = 'todo';
    
    // tabella della vista
	$ct['view']['table'] = 'attivita';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.ticket.form';

     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'data_attivita' => 'esecuzione',
	    '__label__' => 'attività',
	    'anagrafica' => 'svolta da',
	    'ore' => 'ore',
        'testo' => 'testo',
        'note_interne' => 'note_interne'
    );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left',
	    'anagrafica' => 'text-left no-wrap',
        'note_interne' => 'd-none',
        'testo' => 'd-none'
    );
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.ticket.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'attivita.ticket.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_todo';

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
	    $ct['view']['__restrict__']['id_todo']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

 /*   if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
            if(!empty($row['data_programmazione'])){$row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione']));}

            if(!empty($row['data_attivita'])){$row['data_attivita'] = date('d/m/Y', strtotime($row['data_attivita']));}
            $row['ora_inizio_programmazione'] = substr( $row['ora_inizio_programmazione'], 0, -3);
            $row['__label__'] = $row['note_interne'].( empty($row['note_interne']) ? '' : '; <br>').$row['testo'];
		}
	}
*/