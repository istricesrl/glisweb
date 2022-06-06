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
    $ct['view']['table'] = 'todo';
    
    // id della vista
   # $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'todo.amministrazione.form';

     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
#	    'data_programmazione' => 'pianificato',
#	    'priorita' => 'priorità',
		'tipologia' => 'tipologia',
	    'nome' => 'titolo',
	    'cliente' => 'da fare per',
	    'anagrafica' => 'assegnato a',
		'settimana_programmazione' => 'settimana',
		'anno_programmazione' => 'anno'
#	    'progresso' => 'ore',
#	    'completato' => 'stato',
#	    'id_priorita' => 'id_priorita'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'id_priorita' => 'd-none',
#		'completato' => 'd-none',
	    'cliente' => 'text-left d-none d-md-table-cell',
	    'nome' => 'text-left',
	    'priorita' => 'text-left',
	    'anagrafica' => 'text-left no-wrap d-none d-sm-table-cell',
	    'progresso' => 'text-right no-wrap d-none d-sm-table-cell',
#	    'completato' => 'text-left'
	);

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/todo.view.filters.html';

    // tendina clienti
	$ct['etc']['select']['id_cliente'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_interno = 1 OR se_cliente = 1');

	// tendina tipologie
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_todo_view' );
		
    // macro di default
    require DIR_SRC_INC_MACRO . '_default.view.php';
/*
	// preset filtro custom todo completati
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['completato']['EQ'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['completato']['EQ'] = 0;
    }
*/
	// preset ordinamento
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['anno_programmazione'] = 'ASC';
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['settimana_programmazione'] = 'ASC';
    }
    
/*    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] ) || $_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] == '__me__' ) {
		$_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] = '__me__';
		if( isset( $_SESSION['account']['id_anagrafica'] ) ) {
		    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_responsabile']['EQ'] = $_SESSION['account']['id_anagrafica'];
		}
	    } elseif( $_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] == '__nessuno__' ) {
		$_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] = '__nessuno__';
		if( isset( $_SESSION['account']['id_anagrafica'] ) ) {
		    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_responsabile']['NL'] = true;
		}
	}
  */  
  if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] ) ){ 
	$_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] = '__tutti__'; 
}
/*
	if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
			if( $row['completato'] == 2 ){ $row['completato']='completato';  }
			else {
			if( $row['completato'] == 1 ){ $row['completato']='in revisione';  }
			else { $row['completato']='';  }
			}
		}
	}
*/
