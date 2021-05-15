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
	$ct['view']['table'] = 'progetti_commerciale';

    // id della vista
    $ct['view']['id'] = md5( $ct['view']['table'] );

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'progetti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'progetti.commerciale.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'cliente' => 'cliente',
        'tipologia' => 'tipologia',
        '__label__' => 'nome'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'cliente' => 'text-left d-none d-md-table-cell',
        'tipologia' => 'text-left',
        '__label__' => 'text-left'
    );

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/progetti.commerciale.view.filters.html';

    // tendina clienti
	$ct['etc']['select']['id_cliente'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view WHERE se_interno = 1 OR se_cliente = 1');

	// tendina tipologie
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_progetti_view' );
 

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
