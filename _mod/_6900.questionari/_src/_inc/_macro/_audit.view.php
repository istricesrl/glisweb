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
    $ct['view']['table'] = 'audit';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'audit.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'progetto' => 'progetto',
        'somministratore' => 'somministratore',
        'data_audit' => 'data',
        'nome' => 'nome'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'data_audit' => 'text-left',
        'progetto' => 'text-left',
        'somministratore' => 'text-left'
    );

    // tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][$mese] =  int2month( $mese ) ;
	}

    // tendina anni
	foreach( range( date( 'Y' ) - 5,  date( 'Y' ) ) as $y ) {
	    $ct['etc']['select']['anni'][$y] = $y ;
	}

    // tendina somministratori
	$ct['etc']['select']['somministratori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_interno = 1 OR se_collaboratore = 1');

    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM progetti_view');

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/audit.view.filters.html';


    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

