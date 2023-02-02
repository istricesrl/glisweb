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
        'codici_contraenti' => 'codice cliente',
        'contraenti' => 'cliente',
        'proponenti' => 'proponenti',
//        'progetto' => 'progetto', TODO solo se il modulo progetti è attivo
//        'immobile' => 'immobile', TODO solo se il modulo immobili è attivo
        'tipologia' => 'tipologia',
        'tipologia_licenza' => 'versione',
        'licenze' => 'licenze', // TODO se è attivo il modulo ???
        'postazioni' => 'postazioni',
        'data_inizio' => 'inizio',
        'data_fine' => 'fine'
//	    '__label__' => 'contratto'
	);

    // stili della vista
	$ct['view']['class'] = array(
//	    'id' => 'd-none', TODO nascondere per 2Si
	    '__label__' => 'text-left no-wrap',
        'contraenti' => 'text-left',
//        'proponenti' => 'text-left d-none', TODO nascondere per 2Si
        'progetto' => 'text-left',
        'immobile' => 'text-left',
        'tipologia' => 'text-left',
        'licenze' => 'text-left',
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
