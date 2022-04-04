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
    $ct['form']['table'] = 'anagrafica';
    
    // tabella della vista
	$ct['view']['table'] = 'attivita';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';

     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'data_programmazione' => 'programmata',
        'ora_inizio_programmazione' => 'ora',
        'data_attivita' => 'esecuzione',
	    '__label__' => 'attività',
	    'anagrafica' => 'svolta da',
	    'ore' => 'ore',
        'nome' => 'testo'    );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left',
	    'data_programmazione' => 'text-left no-wrap',
	    'ora_inizio_programmazione' => 'text-left no-wrap',
	    'anagrafica' => 'text-left no-wrap',
        'nome' => 'd-none'
    );

    $ct['etc']['include']['insert'] = 'inc/anagrafica.form.attivita.insert.html';
	$ct['view']['insert']['field'] = 'id_cliente';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'attivita.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_anagrafica';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_cliente']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

     // tendina tipologia attivita
	 $ct['etc']['id_tipologia_attivita'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, nome AS __label__ FROM tipologie_attivita WHERE se_agenda = 1 ORDER BY nome' );

     $ct['etc']['select']['id_tipologia'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view' );

        // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

	require DIR_SRC_INC_MACRO . '_default.form.php';

    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
            if(!empty($row['data_programmazione'])){$row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione']));}

            if(!empty($row['data_attivita'])){$row['data_attivita'] = date('d/m/Y', strtotime($row['data_attivita']));}
            $row['ora_inizio_programmazione'] = substr( $row['ora_inizio_programmazione'], 0, -3);
          //s  $row['__label__'] = $row['note_interne'].( empty($row['note_interne']) ? '' : '; <br>').$row['testo'];
		}
	}