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
        'contraenti' => 'contraenti',
        'proponenti' => 'proponenti',
        'progetto' => 'progetto',
        'immobile' => 'immobile',
        'tipologia' => 'tipologia',
	    '__label__' => 'contratto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap',
        'contraenti' => 'text-left',
        'proponenti' => 'text-left',
        'progetto' => 'text-left',
        'immobile' => 'text-left',
        'tipologia' => 'text-left',
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
