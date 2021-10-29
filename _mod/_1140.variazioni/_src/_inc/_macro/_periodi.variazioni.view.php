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
    $ct['view']['table'] = 'periodi_variazioni_attivita';
    
    // id della vista
    $ct['view']['id'] = md5(
		$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
	    );
        
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'variazioni.form';

    $ct['view']['open']['table'] = 'variazioni_attivita';

    $ct['view']['open']['field'] = 'id_variazione';


    // campi della vista
	$ct['view']['cols'] = array(
    #    'id' => '#',
        'id_variazione' => 'variazione',
        'tipologia' => 'tipologia',
        'anagrafica' => 'anagrafica',
        'data_inizio' => 'data inizio',
        'ora_inizio' => 'ora inizio',
        'data_fine' => 'data fine',
        'ora_fine' => 'ora fine'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'anagrafica' => 'text-left d-none d-md-table-cell'
    );
    
    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/periodi.variazioni.view.filters.html';

    // tendina operatori
	$ct['etc']['select']['operatori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1 ORDER BY __label__');

    // tendina tipologie variazioni
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_variazioni_attivita_view');

    // preset filtro custom variazioni da approvare
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['approvata']['EQ'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['approvata']['EQ'] = 1;
    }  

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
