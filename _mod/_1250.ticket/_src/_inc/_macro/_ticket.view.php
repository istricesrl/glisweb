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
    $ct['view']['table'] = 'ticket_attivi';
    
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
		'data_ultima_attivita' => 'aggiornato',
		'data_prossima_attivita' => 'prossima azione',
#	    'responsabile' => 'assegnato a',
#	    'completato' => 'stato'
		NULL => 'azioni'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'cliente' => 'text-left d-none d-md-table-cell',
		'ranking_cliente' => 'd-none',
	    'nome' => 'text-left',
		'tipologia' => 'd-none',
		'tipologia_progetto' => 'd-none',
		'progetto' => 'text-left',
		'data_ultima_attivita' => 'text-left',
		'data_prossima_attivita' => 'text-left',
#	    'responsabile' => 'text-left no-wrap d-none d-sm-table-cell',
#	    'completato' => 'text-left'
		NULL => 'no-wrap'
	);

    // Javascript della vista
	$ct['view']['onclick'] = array(
		NULL => 'event.stopPropagation();'
	);

	// altre configurazioni della vista
	$ct['view']['etc'] = array(
		'__force_backurl__' => 1
	);

    // inclusione filtri speciali
	// $ct['etc']['include']['filters'] = 'inc/ticket.view.filters.html';

    // tendina clienti
	$ct['etc']['select']['clienti'] = mysqlCachedIndexedQuery(
		$cf['memcache']['index'],
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_interno = 1 OR se_cliente = 1');

	// tendina tipologie
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_todo_view WHERE se_ticket = 1' );

    // tendina collaboratori
	$ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1' );

	$ct['etc']['include']['insert'][] = array(
		'name' => 'insert',
		'file' => 'inc/ticket.view.insert.html',
		'fa' => 'fa-plus-circle'
	);

	// macro di default
    require DIR_SRC_INC_MACRO . '_default.view.php';
    
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] ) ){
		$_REQUEST['__view__'][ $ct['view']['id'] ]['__extra__']['assegnato'] = '__tutti__'; 
	}

	if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){

			$row['progetto'] = '(' . $row['tipologia_progetto'] . ') ' . $row['progetto'];

            $lastAction = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT * FROM attivita WHERE attivita.id_todo = ? AND data_attivita IS NOT NULL ORDER BY data_attivita DESC LIMIT 1',
                array( array( 's' => $row['id'] ) )
            );

            if( ! empty( $lastAction ) ) {
                $row['data_ultima_attivita'] .= ' ' . implode( '<br>', array( $lastAction['nome'], $lastAction['note'] ) );
            }

            $nextAction = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT * FROM attivita WHERE attivita.id_todo = ? AND data_attivita IS NULL AND data_programmazione IS NOT NULL ORDER BY data_programmazione ASC LIMIT 1',
                array( array( 's' => $row['id'] ) )
            );

            if( ! empty( $nextAction ) ) {
                $row['data_prossima_attivita'] = '<a href="'.$cf['contents']['pages']['attivita.form']['url'][LINGUA_CORRENTE].'?attivita[id]='.$nextAction['id'].'&__backurl__='.$ct['page']['backurl'][LINGUA_CORRENTE].'" onclick="event.stopPropagation();">' . $row['data_prossima_attivita'] . ' ' . implode( '<br>', array( $nextAction['nome'], $nextAction['note_programmazione'] ) ) . '</a>';
            }

            $row[ NULL ] = 
                '<a href="'.$cf['contents']['pages']['attivita.form']['url'][LINGUA_CORRENTE].'?__preset__[attivita][id_todo]='.$row['id'].'&__preset__[attivita][data_attivita]='.date('Y-m-d').'&__backurl__='.$ct['page']['backurl'][LINGUA_CORRENTE].'"><i class="fa fa-pencil-square-o"></i></a>'.
                '<a href="'.$cf['contents']['pages']['attivita.form']['url'][LINGUA_CORRENTE].'?__preset__[attivita][id_todo]='.$row['id'].'&__preset__[attivita][data_programmazione]='.date('Y-m-d',strtotime('+1 day')).'&__backurl__='.$ct['page']['backurl'][LINGUA_CORRENTE].'"><i class="fa fa-calendar-plus-o"></i></a>';

		}
	}
