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
	$ct['view']['table'] = 'progetti_amministrazione';

    $ct['view']['id'] = md5(
		$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
	    );
        
    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'progetti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'progetti.amministrazione.form';

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
	$ct['etc']['include']['filters'] = 'inc/progetti.amministrazione.view.filters.html';

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
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_progetti_view' );

/*
    // preset filtro aperti
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['chiuso']['EQ'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['chiuso']['EQ'] = 0;
    }
 */
    
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';