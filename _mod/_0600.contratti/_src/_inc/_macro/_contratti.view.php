<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

   // tabella della vista
    $ct['view']['table'] = 'contratti';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'contratti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'parti' => 'parti',
        'progetto' => 'progetto',
        'immobile' => 'immobile',
        'tipologia' => 'tipologia',
	    '__label__' => 'contratto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap'
	);

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/contratti.view.filters.html';

    // tendina tipologia
	$ct['etc']['select']['tipologie_contratti'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_contratti_view'
    );
    
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
