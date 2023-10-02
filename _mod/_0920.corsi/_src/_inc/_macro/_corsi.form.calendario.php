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

    $ct['view']['data']['__report_mode__'] = 1;
    $ct['view']['table'] = '__report_lezioni_corsi__';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'lezioni.form';
    $ct['view']['open']['table'] = 'todo';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'lezioni.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_progetto';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'data_programmazione' => 'data',
        'ora_inizio_programmazione' => 'ora inizio',
        'ora_fine_programmazione' => 'ora fine',
        'luogo' => 'luogo',
        'anagrafica' => 'responsabile',
        'docenti' => 'docenti',
        'numero_alunni' => 'iscritti',
        'id_progetto' => 'id_progetto'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'id_progetto' => 'd-none',
    #		'completato' => 'd-none',
        'ora_fine_programmazione' => 'text-left d-none d-md-table-cell',
        'luogo' => 'text-left',
        'ora_inizio_programmazione' => 'text-left',
        'anagrafica' => 'text-left no-wrap d-none d-sm-table-cell',
        'docenti' => 'text-left no-wrap d-none d-sm-table-cell',
        'data_programmazione' => 'text-left',
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

    $ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_periodi_view'
    );

    $ct['etc']['select']['giorni_settimana'] = array(
        array( 'id' => 0, '__label__' => 'lunedì' ),
        array( 'id' => 1, '__label__' => 'martedì' ),
        array( 'id' => 2, '__label__' => 'mercoledì' ),
        array( 'id' => 3, '__label__' => 'giovedì' ),
        array( 'id' => 4, '__label__' => 'venerdì' ),
        array( 'id' => 5, '__label__' => 'sabato' ),
        array( 'id' => 6, '__label__' => 'domenica' )
    );

    $ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1' );
        
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

    $ct['etc']['include']['insert'][] = array(
        'name' => 'delete',
        'file' => 'inc/corsi.form.calendario.delete.html',
        'fa' => 'fa-trash'
    );

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';
        
    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';

