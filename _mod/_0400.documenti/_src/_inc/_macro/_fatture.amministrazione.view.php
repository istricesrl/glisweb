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
	$ct['view']['table'] = 'fatture_attive';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'fatture.amministrazione.form';

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'documenti';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'numero' => 'num.',
        'sezionale' => 'sez.',
        'data' => 'data',
#        'emittente' => 'emittente',
        'destinatario' => 'cliente',
        'nome' => 'nome'
    );

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'data' => 'no-wrap',
        'nome' => 'text-left',
        'destinatario' => 'text-left',
        'emittente' => 'text-left',
        'tipologia' => 'text-left',
        'totale' => 'text-right' 
    );

    // tendina mittenti
	$ct['etc']['select']['id_emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_gestita = 1 ORDER BY __label__'
	);

    // tendina destinatari
	$ct['etc']['select']['id_destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_cliente = 1 ORDER BY __label__'
	);

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/fatture.amministrazione.view.filters.html';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
