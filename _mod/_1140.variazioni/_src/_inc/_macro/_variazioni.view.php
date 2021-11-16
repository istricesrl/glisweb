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
    $ct['view']['table'] = 'variazioni_attivita';
    
    // id della vista
    $ct['view']['id'] = md5(
		$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
	    );
        
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'variazioni.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_richiesta' => 'richiesta',
        'data_approvazione' => 'approvazione',
        'data_rifiuto' => 'rifiuto',
        'periodo_variazione' => 'periodo variazione',
        'anagrafica' => 'operatore',
        'tipologia' => 'tipologia',
        'tipologia_inps' => 'tipologia INPS'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'anagrafica' => 'text-left d-none d-md-table-cell'
    );
    
    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/variazioni.view.filters.html';

    // tendina operatori
	$ct['etc']['select']['operatori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1 ORDER BY __label__');

    // tendina tipologie attività inps
	$ct['etc']['select']['tipologie_attivita_inps'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_inps_view ORDER BY id');

    // tendina tipologie variazioni
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_variazioni_attivita_view');

    // preset filtro custom variazioni da approvare
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['approvata']['EQ'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['approvata']['EQ'] = 0;
    }  

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
