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
    $ct['view']['table'] = 'recuperi';
    
    // id della vista
    // TODO fare una funzione getViewId()
    $ct['view']['id'] = md5(
		$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
	);
        
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'presenze.form';
	$ct['view']['open']['table'] = 'attivita';

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
        'data_programmazione' => 'data',
	    'anagrafica' => 'iscritto',
        'tipologia' => 'tipologia',
        'ora_inizio_programmazione' => 'ora',
        'ora_fine_programmazione' => 'ora fine',
/*
        'cliente' => 'cliente',
        'data_programmazione' => 'programmata',
        'anagrafica_programmazione' => 'assegnata a',
        'data_attivita' => 'eseguita',
	    'anagrafica' => 'svolta da',
        'nome' => 'attività',
	    'ore' => 'ore',
        'ora_inizio' => 'oi',
        'ora_fine' => 'of'
*/
        'discipline' => 'discipline',
        'progetto' => 'corso',
        'luogo' => 'luogo',
        'data_programmazione_recupero' => 'data recupero',
        NULL => 'azioni'
      );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left',
        'cliente' => 'text-left d-none d-md-table-cell',
        'anagrafica_programmazione' => 'text-left',
	    'data_programmazione' => 'no-wrap',
	    'data_programmazione_recupero' => 'no-wrap',
        'ora_inizio_programmazione' => 'd-none',
        'ora_fine_programmazione' => 'd-none',
        'data_attivita' => 'no-wrap',
	    'anagrafica' => 'text-left no-wrap',
        'nome' => 'text-left',
        'ora_inizio' => 'd-none',
        'ora_fine' => 'd-none',
        NULL => 'nowrap'
    );

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    // inclusione filtri speciali
	// $ct['etc']['include']['filters'] = 'inc/attivita.view.filters.html';

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
        'SELECT id, __label__ FROM anagrafica_view_static ORDER BY __label__');

    // tendina tipologie attività
	$ct['etc']['select']['tipologie_attivita'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL ORDER BY __label__');
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
/*	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) && isset($_SESSION['account']['id_anagrafica'] ) ){
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] = $_SESSION['account']['id_anagrafica'] ;
	} */

    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['data_attivita']) ){
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['data_attivita']	= 'ASC';
    } 

    // preset filtro custom progetti aperti
    $ct['view']['__restrict__']['id_tipologia']['EQ'] = 19;

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
             if(! empty($row['data_programmazione'])){
//                $row['data_attivita'] = date('d/m/Y', strtotime($row['data_attivita']));
                $row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione'])).' '.substr($row['ora_inizio_programmazione'],0,5).' &mdash; '.substr($row['ora_fine_programmazione'],0,5);

                if( empty( $row['data_programmazione_recupero'] ) ) {
                    $row[ NULL ] =  '<a href="'.$cf['contents']['pages']['lezioni.view']['url'][ LINGUA_CORRENTE ].'?__work__[recuperi][items][1][id]='.$row['id'].'&__work__[recuperi][items][1][label]=recupero lezione per '.$row['anagrafica'].'"><span class="media-left"><i class="fa fa-calendar"></i></span></a>';
                }

            }
        }
	}
