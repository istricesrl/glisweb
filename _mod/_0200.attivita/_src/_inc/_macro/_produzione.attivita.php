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

    // debug
	// print_r( $_SESSION );

    // tabella della vista
    $ct['view']['table'] = 'cartellini';
    $ct['view']['open']['table'] = 'attivita';
    $ct['view']['etc']['__force_backurl__'] = 1;

    // id della vista
    $ct['view']['id'] = md5(
		$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
	);
        
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';
/*
    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_attivita' => 'data',
        'anagrafica' => 'operatore',
        'id_anagrafica' => 'id_anagrafica',
        'cliente' => 'cliente',
        'tipologia' => 'tipologia',
        'nome' => 'attivita',
        'ore' => 'ore'
    //    'tipologia_inps' => 'tipologia INPS',
        
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'id_anagrafica' => 'd-none',
        'anagrafica' => 'no-wrap',
        'cliente' => 'text-left d-none d-md-table-cell',
        'data_attivita' => 'no-wrap',
        'ore' => 'text-right no-wrap',
        'nome' => 'text-left',
        'tipologia' => 'text-left',
        '__label__' => 'text-left',
        'testo' => 'text-left no-wrap'
    );
*/
     // campi della vista
     $ct['view']['cols'] = array(
	    'id' => '#',
        'tipologia' => 'tipologia',
        'cliente' => 'cliente',
//        'data_programmazione' => 'programmata',
//        'ora_inizio_programmazione' => 'ora',
//        'ora_fine_programmazione' => 'ora fine',
//        'anagrafica_programmazione' => 'assegnata a',
        'data_attivita' => 'eseguita',
	    'anagrafica' => 'svolta da',
        'nome' => 'attività',
	    'ore' => 'ore',
//        'ora_inizio' => 'oi',
//        'ora_fine' => 'of'
      );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left',
        'cliente' => 'text-left d-none d-md-table-cell',
        'anagrafica_programmazione' => 'text-left',
	    'data_programmazione' => 'no-wrap',
        'ora_inizio_programmazione' => 'd-none',
        'ora_fine_programmazione' => 'd-none',
	    'anagrafica' => 'text-left no-wrap',
        'nome' => 'text-left no-wrap',
        'ora_inizio' => 'd-none',
        'ora_fine' => 'd-none'
    );

    // totali della vista
	$ct['view']['footer']['cols'] = array(
        'ore' => array( 'label' => 'totale ore', 'function' => 'SUM' )
    );

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/produzione.attivita.filters.html';

    // inserimento rapido
    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/produzione.attivita.insert.html',
        'fa' => 'fa-plus-circle'
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
	$ct['etc']['select']['operatori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_interno = 1 OR se_collaboratore = 1 ORDER BY __label__');

    // tendina clienti
	$ct['etc']['select']['clienti'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_cliente = 1 ORDER BY __label__');
/*
    // tendina tipologie attività
	$ct['etc']['select']['tipologie_attivita'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL ORDER BY __label__');
*/
    // tendina tipologie
    $ct['etc']['select']['id_tipologia'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL ORDER BY __label__' );
        
    // tendina mastri
	$ct['etc']['select']['registri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM registri_view'
    );

/*
    // tendina tipologie attività inps
	$ct['etc']['select']['tipologie_attivita_inps'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_inps_view ORDER BY id');
*/
/*
    // preset filtri custom
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['giorno_attivita']['EQ'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno_attivita']['EQ'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese_attivita']['EQ'] ) ) {
	    // $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] = date('m');
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno_attivita']['EQ'] = date('Y');
	//    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['giorno']['EQ'] = date('d');
    }
*/
/*
 */

    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) && isset($_SESSION['account']['id_anagrafica'] ) ){
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] = $_SESSION['account']['id_anagrafica'] ;
    }

    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno_attivita']['EQ'] ) ){
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno_attivita']['EQ'] = date( 'Y' ) ;
    }

    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese_attivita']['EQ'] ) ){
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese_attivita']['EQ'] = date( 'm' ) ;
    }

    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['giorno_attivita']['EQ'] ) ){
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['giorno_attivita']['EQ'] = date( 'd' ) ;
    }

    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['data_attivita']) ){
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['data_attivita']	= 'ASC';
    } 

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
             if(!empty($row['data_attivita'])){
                $row['data_attivita'] = date('d/m/Y', strtotime($row['data_attivita']));
            }
        }
	}