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
    $ct['view']['data']['__report_mode__'] = 1;
    $ct['view']['table'] = '__report_lezioni_corsi__';
    $ct['view']['etc']['__force_backurl__'] = 1;

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'lezioni.form.presenze';
    $ct['view']['open']['table'] = 'todo';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'lezioni.form';

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
        'discipline' => 'discipline',
        'progetto' => 'progetto',
        'data_programmazione' => 'data',
        'ora_inizio_programmazione' => 'ora inizio',
        'ora_fine_programmazione' => 'ora fine',
        'luogo' => 'luogo',
        'anagrafica' => 'responsabile',
        'docenti' => 'docenti',
        'numero_alunni' => 'iscritti',
        'posti_prova' => 'posti prova',
        'id_progetto' => 'id_progetto'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'd-none',
        'id_progetto' => 'd-none',
    #		'completato' => 'd-none',
        'ora_fine_programmazione' => 'text-left d-none d-md-table-cell',
        'luogo' => 'text-left',
        'ora_inizio_programmazione' => 'text-left',
        'anagrafica' => 'd-none',
        'docenti' => 'd-none',
        'data_programmazione' => 'text-left',
    #	    'completato' => 'text-left'
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
    $ct['view']['__restrict__']['se_prova']['EQ'] = 1;

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
             if(!empty($row['data_attivita'])){
                // $row['data_attivita'] = date('d/m/Y', strtotime($row['data_attivita']));
                $row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione'])).' '.substr($row['ora_inizio_programmazione'],0,5);
            }
        }
	}
