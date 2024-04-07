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
    // print_r( $_REQUEST );

    // ...
    if( isset( $_REQUEST['__chiudi___id_attivita'] ) ) {
        if( isset( $_REQUEST['__chiudi___esito'] ) && $_REQUEST['__chiudi___esito'] == 1 ) {
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE attivita SET data_attivita = ?, timestamp_aggiornamento = unix_timestamp() 
                WHERE id = ?',
                array(
                    array( 's' => date('Y-m-d') ),
                    array( 's' => $_REQUEST['__chiudi___id_attivita'] )
                )
            );
        } elseif( isset( $_REQUEST['__chiudi___esito'] ) && $_REQUEST['__chiudi___esito'] == 0 ) {
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE attivita SET data_attivita = NULL, timestamp_archiviazione = unix_timestamp(), timestamp_aggiornamento = unix_timestamp() 
                WHERE id = ?',
                array(
                    array( 's' => $_REQUEST['__chiudi___id_attivita'] )
                )
            );
        }
        mysqlQuery(
            $cf['mysql']['connection'],
            'REPLACE INTO attivita_view_static SELECT * FROM attivita_view WHERE id = ?',
            array(
                array( 's' => $_REQUEST['__chiudi___id_attivita'] )
            )
        );
    } elseif( isset( $_REQUEST['__archivia___id_attivita'] ) ) {
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET timestamp_archiviazione = unix_timestamp(), timestamp_aggiornamento = unix_timestamp() 
            WHERE id = ?',
            array(
                array( 's' => $_REQUEST['__archivia___id_attivita'] )
            )
        );
        mysqlQuery(
            $cf['mysql']['connection'],
            'REPLACE INTO attivita_view_static SELECT * FROM attivita_view WHERE id = ?',
            array(
                array( 's' => $_REQUEST['__archivia___id_attivita'] )
            )
        );
    }

    // tabella della vista
    $ct['view']['table'] = 'attivita';
    
    // id della vista
    // TODO fare una funzione getViewId()
    $ct['view']['id'] = md5(
		$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
	);
        
    // pagina per la gestione degli oggetti esistenti
	// $ct['view']['open']['page'] = 'presenze.form';
	$ct['view']['open']['table'] = 'attivita';

/*
    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_programmazione' => 'data',
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
        'data_programmazione' => 'no-wrap',
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
	    'id_anagrafica' => 'ID iscritto',
	    'anagrafica' => 'iscritto',
        'tipologia' => 'tipologia',
        'ora_inizio_programmazione' => 'ora',
        'ora_fine_programmazione' => 'ora fine',
/*
        'cliente' => 'cliente',
        'data_programmazione' => 'programmata',
        'anagrafica_programmazione' => 'assegnata a',
        'data_programmazione' => 'eseguita',
	    'anagrafica' => 'svolta da',
        'nome' => 'attività',
	    'ore' => 'ore',
        'ora_inizio' => 'oi',
        'ora_fine' => 'of'
*/
        'timestamp_archiviazione' => 'archiviazione',
        'discipline' => 'discipline',
        'id_progetto' => 'ID corso',
        'progetto' => 'corso',
        'luogo' => 'luogo',
        'data_attivita' => 'frequentata',
        NULL => 'azioni'
      );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left',
        'cliente' => 'text-left d-none d-md-table-cell',
        'id_anagrafica' => 'd-none',
        'anagrafica_programmazione' => 'text-left',
	    'data_programmazione' => 'no-wrap',
        'ora_inizio_programmazione' => 'd-none',
        'ora_fine_programmazione' => 'd-none',
        'data_programmazione' => 'no-wrap',
	    'anagrafica' => 'text-left no-wrap',
        'nome' => 'text-left',
        'id_progetto' => 'd-none',
        'progetto' => 'text-left',
        'timestamp_archiviazione' => 'd-none',
        'discipline' => 'text-left',
        'luogo' => 'd-none',
        'ora_inizio' => 'd-none',
        'ora_fine' => 'd-none',
        NULL => 'nowrap'
    );

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/prove.view.filters.html';

    $ct['page']['contents']['modals']['metro'][] = array(
        'schema' => 'inc/prove.modal.attivita.html'
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

    // preset filtro custom progetti aperti
    $ct['view']['__restrict__']['id_tipologia']['EQ'] = 33;

    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['timestamp_archiviazione']['NL'] ) ) {
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['timestamp_archiviazione']['NL'] = 1;
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['timestamp_archiviazione']['NN'] = NULL;
    } elseif( empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['timestamp_archiviazione']['NL'] ) ) {
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['timestamp_archiviazione']['NL'] = NULL;
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['timestamp_archiviazione']['NN'] = 1;
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['data_programmazione']) ){
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['data_programmazione']	= 'ASC';
    } 

    if( !empty( $ct['view']['data'] ) ) {
		foreach ( $ct['view']['data'] as &$row ) {

            $buttons = '';

            if( $row['data_programmazione'] < date('Y-m-d') ) {
            
                if( ! empty( $row['data_attivita'] ) ) {
    //                $row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione']));
    //                $row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione'])).' '.substr($row['ora_inizio_programmazione'],0,5).' &mdash; '.substr($row['ora_fine_programmazione'],0,5);

                    $row['data_attivita'] = 'sì';

                    $discipline = explode( ' > ', $row['discipline'] );
                    if( is_array( $discipline ) ) {
                        $row['discipline'] = end( $discipline );
                    }

                    if( in_array( "0920.corsi", $cf['mods']['active']['array'] ) ) {
                        // TODO mandare all'elenco corsi con l'anagrafica bookmarkata e il filtro per la disciplina cui appartiene il corso
                        // $buttons .= '<a href="#" data-toggle="modal" data-target="#scorciatoia_promemoria" onclick="window.open(\''.$cf['contents']['pages']['corsi.view']['path'][ LINGUA_CORRENTE ].'?__work__[progetti][items][1][id]='.$row['id'].'&amp;__work__[progetti][items][1][label]='.$row['progetto'].'&amp;__work__[anagrafica][items][1][id]='.$row['id'].'&amp;__work__[anagrafica][items][1][label]='.$row['progetto'].'\',\'_self\');"><i class="fa fa-graduation-cap"></i></a>';
                    }

                    if( in_array( "0640.abbonamenti", $cf['mods']['active']['array'] ) ) {
                        $buttons .= '<a href="#" data-toggle="modal" data-target="#scorciatoia_promemoria" onclick="window.open(\''.$cf['contents']['pages']['abbonamenti.form']['path'][ LINGUA_CORRENTE ].'?__preset__[contratti][id_anagrafica]='.$row['id_anagrafica'].'\',\'_self\');"><i class="fa fa-calendar"></i></a>';
                    }

                    if( empty( $row['timestamp_archiviazione'] ) ) {
                        $onclick = "$('#__archivia___id_attivita').val('".$row['id']."'); $('#archivia_attivita').modal('show');";
                        $buttons .= '<a href="#" data-toggle="modal" data-target="#archivia_attivita" onclick="'.$onclick.'"><i class="fa fa-archive"></i></a>';
                    }

                    $row['data_attivita'] = 'sì';

                } elseif( $row['data_programmazione'] < date('Y-m-d') ) {

                    if( empty($row['data_attivita']) ) {

                        $onclick = "$('#__chiudi___id_attivita').val('".$row['id']."'); $('#chiudi_attivita').modal('show');";
                        $buttons .= '<a href="#" data-toggle="modal" data-target="#chiudi_attivita" onclick="'.$onclick.'"><i class="fa fa-check-square-o"></i></a>';

                        $row['data_attivita'] = 'no';
        
                    }

                }

            }

            $row[ NULL ] = $buttons;

        }
	}
