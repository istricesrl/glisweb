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
	$ct['view']['table'] = 'attivita';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';

    $ct['view']['cols'] = array(
		'id' => '#',
        'data_attivita' => 'data',
        'tipologia' => 'tipologia',
        'anagrafica' => 'persona',
        'nome' => 'attivita',
        'ore' => 'ore'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'anagrafica' => 'text-left',
	    'nome' => 'text-left'
	);

    // inserimento rapido
    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/progetti.produzione.form.attivita.insert.html',
        'fa' => 'fa-plus-circle'
    );

    $ct['etc']['select']['id_tipologia'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL ORDER BY __label__' );
        
    // tendina mastri
	$ct['etc']['select']['registri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM registri_view WHERE id_progetto = ?',
        array(
            array(
                's' => $_REQUEST[ $ct['form']['table'] ]['id']
            )
        )
    );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'attivita.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_progetto';

	// campo preset per la data attività
	$ct['view']['open']['preset']['fields']['data_attivita'] = date( 'Y-m-d' );

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_progetto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
