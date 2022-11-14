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
    $ct['form']['table'] = 'progetti';
    
    // tabella della vista
	$ct['view']['table'] = '__report_backlog_todo__';
    $ct['view']['data']['__report_mode__'] = 1;

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'todo';
	$ct['view']['open']['page'] = 'todo.form';

    $ct['view']['cols'] = array(
	    'id' => '#',
#	    'data_programmazione' => 'pianificato',
#	    'priorita' => 'priorità',
		'tipologia' => 'tipologia',
	    'nome' => 'titolo',
	    'anagrafica' => 'assegnato a',
		'ore_programmazione' => 'ore programmate',
#		'settimana_programmazione' => 'settimana',
#		'anno_programmazione' => 'anno'
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
	    'ore_programmazione' => 'd-none',
	    'priorita' => 'text-left',
	    'anagrafica' => 'text-left no-wrap d-none d-sm-table-cell',
	    'progresso' => 'text-right no-wrap d-none d-sm-table-cell',
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

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_progetto';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_progetto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

	// ...
    $ct['page']['contents']['modals']['metro'][] = array(
        'schema' => 'inc/produzione.backlog.modal.todo.html'
    );

    // tendina anni
	foreach( range( date( 'Y' ) + 1, 2017 ) as $y ) {
	    $ct['etc']['select']['anni'][] = array( 'id' => $y, '__label__' => $y );
	}

    // tendina settimane
	foreach( range( 1, 52 ) as $w ) {
	    $ct['etc']['select']['settimane'][] = array( 'id' => $w, '__label__' => $w . ' / ' . substr( int2month( ceil( $w / 4.348125 ) ), 0, 3 ) );
	}

	$ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
		$cf['memcache']['index'],
		$cf['memcache']['connection'],
		$cf['mysql']['connection'], 
		'SELECT id, __label__ FROM anagrafica_view_static' );

    // tendina tipologie
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_todo_view' );

    // inserimento rapido
    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/progetti.produzione.form.backlog.insert.todo.html',
        'fa' => 'fa-plus-circle'
    );

	// gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

	// preset ordinamento
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['anno_programmazione'] = 'ASC';
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['settimana_programmazione'] = 'ASC';
    }

	// icone
	foreach( $ct['view']['data'] as &$row ) {
		$row[ NULL ] = '<a href="#" data-toggle="modal" data-target="#scorciatoia_todo_backlog" onclick="$(\'#todo_id\').val(\''.$row['id'].'\');$(\'#todo_ore_programmazione\').val(\''.$row['ore_programmazione'].'\');$(\'#scorciatoia_todo_backlog\').modal(\'show\');"><i class="fa fa-calendar-plus-o"></i></a>';
	}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
