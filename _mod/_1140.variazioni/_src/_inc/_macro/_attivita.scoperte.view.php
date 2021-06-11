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
	$ct['view']['table'] = 'attivita_scoperte';

    // id della vista
    $ct['view']['id'] = md5( $ct['view']['table'] );

    // tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'attivita';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.scoperte.form';

    $ct['view']['insert']['page'] = ''; // non deve essere possibile inserire nuovi oggetti ma solo gestire quelli esistenti

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_programmazione' => 'data pianificazione',
        'ora_inizio_programmazione' => 'ora inizio',
        'ora_fine_programmazione' => 'ora fine',
        'assente' => 'da sostituire',
        'cliente' => 'cliente',
        'progetto' => 'progetto'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'cliente' => 'text-left d-none d-md-table-cell',
        'progetto' => 'text-left',
        'assente' => 'text-left'
    );

     // inclusione filtri
	$ct['etc']['include']['filters'] = 'inc/attivita.scoperte.view.filters.html';

    // tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][$mese] =  int2month( $mese ) ;
	}

    // tendina anni
	foreach( range( date( 'Y' ) - 5,  date( 'Y' ) ) as $y ) {
	    $ct['etc']['select']['anni'][$y] = $y ;
	}

     // tendina clienti
	$ct['etc']['select']['clienti'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_interno = 1 OR se_cliente = 1'
    );

     // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM progetti_produzione_view'
    );

     // preset filtri custom
/*	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['giorno']['EQ'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] = date('m');
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno']['EQ'] = date('Y');
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['giorno']['EQ'] = date('d');
    }
*/ 

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   