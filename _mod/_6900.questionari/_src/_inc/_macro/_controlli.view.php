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
    $ct['view']['table'] = 'controlli';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'controlli.form';

    $ct['view']['cols'] = array(
        'id' => '#',
        'data_audit' => 'data',
        'progetto' => 'progetto',
		'anagrafica' => 'anagrafica',
		'tipologia_questionario' => 'tipologia',
		'questionario' => 'questionario'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'progetto' => 'text-left',
        'anagrafica' => 'text-left',
        'tipologia_questionario' => 'text-left',
		'questionario' => 'text-left'
    );

    // tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][$mese] =  int2month( $mese ) ;
	}

    // tendina anni
	foreach( range( date( 'Y' ) - 5,  date( 'Y' ) ) as $y ) {
	    $ct['etc']['select']['anni'][$y] = $y ;
	}

    // tendina operatori
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
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

    // tendina tipologie questionari
	$ct['etc']['select']['tipologie_questionari'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_questionari_view');

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/controlli.view.filters.html';


    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

