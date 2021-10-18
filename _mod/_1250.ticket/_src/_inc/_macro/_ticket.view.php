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
    $ct['view']['table'] = 'ticket';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'ticket.form';

	// tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'todo';

     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'nome' => 'titolo',
	    'cliente' => 'da fare per',
	    'responsabile' => 'assegnato a',
	    'completato' => 'stato'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'cliente' => 'text-left d-none d-md-table-cell',
	    'nome' => 'text-left',
	    'responsabile' => 'text-left no-wrap d-none d-sm-table-cell',
	    'completato' => 'text-left'
	);

    // inclusione filtri speciali
#	$ct['etc']['include']['filters'] = 'inc/ticket.view.filters.html';

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
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_ticket = 1' );
		
    // macro di default
    require DIR_SRC_INC_MACRO . '_default.view.php';
    
    // preset filtro custom ticket da completare
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['completato']['EQ'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['completato']['EQ'] = 0;
    }
    
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] ) ){
		$_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] = '__tutti__'; 
	}

	if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
			if( $row['completato'] == 1 ){ $row['completato']='chiuso';  }
			else {
			if( $row['completato'] == 0 ){ $row['completato']='aperto';  }
			else { $row['completato']='';  }
			}
		}
	}
    
