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
	$ct['view']['table'] = 'contratti_produzione';

    $ct['view']['id'] = md5(
		$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
	    );
        
    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'contratti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'contratti.produzione.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'progetto' => 'progetto',
        'tipologia' => 'tipologia',
        '__label__' => 'nome'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'progetto' => 'text-left d-none d-md-table-cell',
        'tipologia' => 'text-left',
        '__label__' => 'text-left'
    );

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/contratti.produzione.view.filters.html';

     // tendina clienti
     $ct['etc']['select']['id_cliente'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_interno = 1 OR se_cliente = 1');

	// tendina tipologie
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_contratti_view WHERE se_produzione = 1' );

 
       // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';