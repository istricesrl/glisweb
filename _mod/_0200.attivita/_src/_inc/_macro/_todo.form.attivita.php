<?php

    /**
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'todo';
    
    // tabella della vista
	$ct['view']['table'] = 'attivita';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';

     // campi della vista
     $ct['view']['cols'] = array(
	    'id' => '#',
        'data_programmazione' => 'programmata',
        'ora_inizio_programmazione' => 'ora',
        'ora_fine_programmazione' => 'ora fine',
        'anagrafica_programmazione' => 'assegnata a',
        'data_attivita' => 'eseguita',
	    'anagrafica' => 'svolta da',
        'nome' => 'attività',
	    'ore' => 'ore',
        'ora_inizio' => 'oi',
        'ora_fine' => 'of'
      );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left',
        'anagrafica_programmazione' => 'text-left',
	    'data_programmazione' => 'text-left no-wrap',
	    'ora_inizio_programmazione' => 'd-none',
        'ora_fine_programmazione' => 'd-none',
	    'anagrafica' => 'text-left no-wrap',
        'nome' => 'text-left no-wrap',
        'ora_inizio' => 'd-none',
        'ora_fine' => 'd-none'
    );
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'attivita.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_todo';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_todo']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/todo.form.attivita.insert.html',
        'fa' => 'fa-plus-circle'
    );

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
	    'SELECT id, __label__ FROM registri_view WHERE id_progetto = ?',
        array(
            array(
                's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto']
            )
        )
    );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
            if( !empty($row['data_programmazione']) && (!empty($row['ora_inizio_programmazione']) || !empty($row['ora_fine_programmazione']) )){ 
                $row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione']) ).'  '.( empty($row['ora_inizio_programmazione']) ? ' '  : date('H:i', strtotime($row['ora_inizio_programmazione']))).' &mdash; '.( empty($row['ora_fine_programmazione']) ? ' ' :date('H:i', strtotime($row['ora_fine_programmazione']) ));}
            elseif( !empty($row['data_programmazione']) ){$row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione']));}

            if( !empty( $row['data_attivita'] ) ){$row['data_attivita'] = date('d/m/Y', strtotime($row['data_attivita']));}
            if( !empty( $row['ora_inizio'] ) || !empty( $row['ora_fine'] ) ){ 
                $row['data_attivita'] = $row['data_attivita'].'  '.( empty($row['ora_inizio']) ? ' '  : date('H:i', strtotime($row['ora_inizio']))).' &mdash; '.( empty($row['ora_fine']) ? ' ' :date('H:i', strtotime($row['ora_fine']) ));
             }
          //s  $row['__label__'] = $row['note_interne'].( empty($row['note_interne']) ? '' : '; <br>').$row['testo'];
		}
	}