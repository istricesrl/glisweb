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
    $ct['view']['table'] = 'ticket_archiviati';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'ticket.form';

	// tabella per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'todo';

     // campi della vista
	 $ct['view']['cols'] = array(
	    'id' => '#',
		'tipologia' => 'tipologia',
	    'nome' => 'titolo',
	    'cliente' => 'da fare per',
		'ranking_cliente' => 'priorità',
		'tipologia_progetto' => 'progetto',
		'progetto' => 'riferimento',
		'data_chiusura' => 'chiuso',
		'data_archiviazione' => 'archiviato',
#	    'responsabile' => 'assegnato a',
#	    'completato' => 'stato'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'cliente' => 'text-left d-none d-md-table-cell',
	    'nome' => 'text-left',
		'tipologia' => 'text-left',
		'tipologia_progetto' => 'd-none',
#	    'responsabile' => 'text-left no-wrap d-none d-sm-table-cell',
#	    'completato' => 'text-left'
	);

    // tendina clienti
	$ct['etc']['select']['clienti'] =  mysqlCachedIndexedQuery(
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
    
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] ) ){
		$_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] = '__tutti__'; 
	}

	if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
			if( $row['completato'] == 2 ){ $row['completato']='chiuso';  }
			else { $row['completato']='';  }
		}
	}
    

   