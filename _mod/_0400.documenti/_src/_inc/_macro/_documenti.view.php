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
    $ct['view']['table'] = 'documenti';
    
    // id della vista
   # $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'tipologia' => 'tipologia',
        'numero' => 'num.',
        'sezionale' => 'sez.',
        'data' => 'data',
        'emittente' => 'emittente',
        'destinatario' => 'destinatario',
        '__label__' => 'nome'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'numero' => 'text-left',
        '__label__' => 'text-left',
        'data' => 'no-wrap', 
        'destinatario' => 'text-left',
        'emittente' => 'text-left',
        'tipologia' => 'text-left',
        'totale' => 'text-right' 
    );

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/documenti.view.filters.html';

    // tendina categoria
	$ct['etc']['select']['tipologie_documenti'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_documenti_view'
	);

     // tendina mittenti
	$ct['etc']['select']['id_emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_gestita = 1'
	);

    // tendina destinatari
	$ct['etc']['select']['id_destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   