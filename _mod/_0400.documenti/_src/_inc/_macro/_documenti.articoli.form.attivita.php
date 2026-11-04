<?php

    /**
     * attivita' di una riga di documento
     *
     * la tabella attivita non ha una colonna id_documenti_articoli: un'attivita' appartiene alla riga attraverso la
     * sua todo ( attivita.id_todo -> todo.id_documenti_articoli ), che e' lo stesso legame che attivita_view usa per
     * quantita_prevista; per questo la vista si filtra su id_todo, con le todo della riga
     *
     * fino al 2026-11-04 la macro chiedeva ad attivita_view note_programmazione, note_interne, testo e
     * id_documenti_articoli, che la vista non ha ( e la tabella non ha nemmeno note_interne e testo ): la scheda
     * si fermava con un 1054 ( polmasi, 2026-11-04 ); la vista non si tocca perche' quella viva ha colonne in piu'
     * del canone su molti database, e ricrearla le toglierebbe
     *
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'documenti_articoli';

    // tabella della vista
	$ct['view']['table'] = 'attivita';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';

     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'data_programmazione' => 'programmata',
        'ora_inizio_programmazione' => 'ora',
        'todo' => 'compito',
        'data_attivita' => 'esecuzione',
	    '__label__' => 'attività',
	    'anagrafica' => 'svolta da',
	    'ore' => 'ore'
    );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left',
	    'data_programmazione' => 'text-left no-wrap',
	    'ora_inizio_programmazione' => 'text-left no-wrap',
	    'anagrafica' => 'text-left no-wrap',
	    'todo' => 'text-left'
    );

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){

        // todo della riga
        $idTodo = mysqlSelectColumn(
            'id',
            $cf['mysql']['connection'],
            'SELECT id FROM todo WHERE id_documenti_articoli = ? ',
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] )
            )
        );

        // preset filtro attivita' delle todo della riga ( una riga senza todo non ha attivita' )
        $ct['view']['__restrict__']['id_todo']['IN'] = ( empty( $idTodo ) ? '0' : implode( '|', $idTodo ) );

    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    if( !empty( $ct['view']['data'] ) ){
		// le date AAAA-MM-GG le ha gia' convertite in GG/MM/AAAA _default.view.php ( dal 2026-09-22 ), e
		// ripassarle da strtotime() leggeva GG/MM come MM/GG ( 01/01/1970 o giorno e mese scambiati ): si
		// riconverte solo quello che e' ancora AAAA-MM-GG, come un datetime che il default lascia com'e'
		foreach ( $ct['view']['data'] as &$row ){
            if(!empty($row['data_programmazione'])){$row['data_programmazione'] = ( preg_match( '/^[0-9]{4}-[0-9]{2}-[0-9]{2}/', $row['data_programmazione'] ) ? date('d/m/Y', strtotime($row['data_programmazione'])) : $row['data_programmazione'] );}

            if(!empty($row['data_attivita'])){$row['data_attivita'] = ( preg_match( '/^[0-9]{4}-[0-9]{2}-[0-9]{2}/', $row['data_attivita'] ) ? date('d/m/Y', strtotime($row['data_attivita'])) : $row['data_attivita'] );}
            if(!empty($row['ora_inizio_programmazione'])){$row['ora_inizio_programmazione'] = substr( $row['ora_inizio_programmazione'], 0, -3);}
		}
	}
