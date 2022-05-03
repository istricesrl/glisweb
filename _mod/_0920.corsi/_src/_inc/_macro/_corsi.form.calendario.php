<?php

    /**
     * macro form progetti produzione tools
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'progetti';

    $ct['view']['table'] = 'todo';

        // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'todo.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'todo.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_progetto';

   // pagina per la gestione degli oggetti esistenti
    $ct['view']['open']['page'] = 'todo.form';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'tipologia' => 'tipologia',
        'nome' => 'titolo',
        'data_programmazione' => 'giorno'
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
    #	    'completato' => 'text-left'
    );

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
        $ct['view']['__restrict__']['id_progetto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    // tendina luoghi
	$ct['etc']['select']['luoghi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM luoghi_view'
    );

	$ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/corsi.form.calendario.insert.html',
        'fa' => 'fa-plus-circle'
    );

	$ct['etc']['include']['insert'][] = array(
        'name' => 'edit',
        'file' => 'inc/corsi.form.calendario.edit.html',
        'fa' => 'fa-pencil'
    );

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';
        
    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';
