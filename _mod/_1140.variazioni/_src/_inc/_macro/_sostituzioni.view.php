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
    $ct['view']['table'] = 'sostituzioni_attivita';
    
    // id della vista
    $ct['view']['id'] = md5( $ct['view']['table'] );


    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_richiesta' => 'richiesta',
        'data_accettazione' => 'accettazione',
        'data_rifiuto' => 'rifiuto',
        'id_attivita' => 'id attività',
        'anagrafica' => 'operatore',
        'progetto' => 'progetto'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'anagrafica' => 'text-left',
        'progetto' => 'text-left'
    );
    
    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/sostituzioni.view.filters.html';

    // tendina operatori
	$ct['etc']['select']['operatori'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1');

    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM progetti_view');


    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   