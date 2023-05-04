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

	// rimozione rapida TODO da sprint
	if( isset( $_REQUEST['__unsprint__'] ) ) {

		// rimuovo la TODO dallo sprint
		mysqlQuery(
			$cf['mysql']['connection'],
			'UPDATE todo SET anno_programmazione = NULL, settimana_programmazione = NULL WHERE id = ?',
			array(
				array( 's' => $_REQUEST['__unsprint__'] )
			)
		);

	}

    // tabella della vista
	$ct['view']['table'] = '__report_planned_todo__';
    $ct['view']['data']['__report_mode__'] = 1;
	$ct['view']['etc']['__force_backurl__'] = 1;

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'todo';
	$ct['view']['open']['page'] = 'todo.form';

    $ct['view']['cols'] = array(
	    'id' => '#',
#	    'data_programmazione' => 'pianificato',
#	    'priorita' => 'priorità',
		'tipologia' => 'tipologia',
		'id_progetto' => 'ID progetto',
		'progetto' => 'progetto',
	    'nome' => 'titolo',
	    'anagrafica' => 'assegnato a',
		'settimana_programmazione' => 'settimana',
		'anno_programmazione' => 'anno',
#	    'progresso' => 'ore',
#	    'completato' => 'stato',
#	    'id_priorita' => 'id_priorita'
		NULL => 'azioni'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'id_priorita' => 'd-none',
#		'completato' => 'd-none',
	    'cliente' => 'text-left d-none d-md-table-cell',
	    'nome' => 'text-left',
	    'priorita' => 'text-left',
	    'anagrafica' => 'text-left no-wrap d-none d-sm-table-cell',
	    'progresso' => 'text-right no-wrap d-none d-sm-table-cell',
		'progetto' => 'text-left'
#	    'completato' => 'text-left'
	);

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

	// pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'todo.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'todo.form';

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

	// icone
	foreach( $ct['view']['data'] as &$row ) {
		if( is_array( $row ) ) {
			$row[ NULL ] = '<a href="' . $cf['page']['path'][ LINGUA_CORRENTE ] . '?__unsprint__=' . $row['id'] . '"><i class="fa fa-calendar-minus-o"></i></a>';
		}
	}

	// preset ordinamento
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['anno_programmazione'] = 'ASC';
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['settimana_programmazione'] = 'ASC';
    }
