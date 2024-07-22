<?php

    /**
     * macro form abbonamenti stampe
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'contratti';

    // tabella della vista
    $ct['view']['table'] = 'attivita';

    // pagina per la gestione degli oggetti esistenti
	// $ct['view']['open']['page'] = 'presenze.form';
	$ct['view']['open']['table'] = 'attivita';

     // campi della vista
     $ct['view']['cols'] = array(
	    'id' => '#',
        'data_attivita' => 'presenza',
        'data_programmazione' => 'data',
	    'id_anagrafica' => 'ID iscritto',
	    'anagrafica' => 'iscritto',
        'tipologia' => 'tipologia',
        'id_tipologia' => 'ID tipologia',
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
        'data_attivita' => 'd-none',
        'id_tipologia' => 'd-none',
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

    // preset filtro custom progetti aperti
    $ct['view']['__restrict__']['id_tipologia']['IN'] = '15|19|32|33|40';
    $ct['view']['__restrict__']['id_anagrafica']['EQ'] = $_REQUEST['contratti']['contratti_anagrafica'][0]['id_anagrafica'];
    $ct['view']['__restrict__']['id_contratto']['EQ'] = $_REQUEST['contratti']['id'];

    // debug
    // die( print_r( $_REQUEST, true ) );
    // die( print_r( $ct['view'], true ) );

    // ...
    if( isset( $_REQUEST['__attesa__'] ) && ! empty( $_REQUEST['__attesa__'] ) ) {
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET data_attivita = NULL, id_tipologia = 40 WHERE id = ?',
            array(
                array( 's' => $_REQUEST['__attesa__'] )
            )
        );
        updateReportLezioniCorsi( $_REQUEST[ $ct['form']['table'] ]['id'] );
        updateAttivitaViewStatic( $_REQUEST['__attesa__'] );
    } elseif( isset( $_REQUEST['__frequenza__'] ) && ! empty( $_REQUEST['__frequenza__'] ) ) {
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET data_attivita = NULL, id_tipologia = 15 WHERE id = ?',
            array(
                array( 's' => $_REQUEST['__frequenza__'] )
            )
        );
        updateReportLezioniCorsi( $_REQUEST['__lezione__'] );
        updateAttivitaViewStatic( $_REQUEST['__frequenza__'] );
    } elseif( isset( $_REQUEST['__presente__'] ) && ! empty( $_REQUEST['__presente__'] ) ) {
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET data_attivita = data_programmazione, id_tipologia = 15 WHERE id = ?',
            array(
                array( 's' => $_REQUEST['__presente__'] )
            )
        );
        updateReportLezioniCorsi( $_REQUEST['__lezione__'] );
        updateAttivitaViewStatic( $_REQUEST['__presente__'] );
    } elseif( isset( $_REQUEST['__assente__'] ) && ! empty( $_REQUEST['__assente__'] ) ) {
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET data_attivita = NULL, id_tipologia = 19 WHERE id = ?',
            array(
                array( 's' => $_REQUEST['__assente__'] )
            )
        );
        updateReportLezioniCorsi( $_REQUEST['__lezione__'] );
        updateAttivitaViewStatic( $_REQUEST['__assente__'] );
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( !empty( $ct['view']['data'] ) ){
        foreach ( $ct['view']['data'] as &$row ){
    
            $buttons = '';
    
            if( $_REQUEST[ $ct['form']['table'] ]['data_programmazione'] < date('Y-m-d') ){
    
                if( empty( $row['data_attivita'] ) ) {
    
                    $onclick = "window.open('?contratti[id]=".$_REQUEST[ $ct['form']['table'] ]['id']."&__lezione__=".$row['id_todp']."&__presente__=".$row['id']."','_self');";
                    $buttons .= '<button type="button" class="button btn btn-secondary btn-xsm" onclick="'.$onclick.'">segna presente</button>';
        
                } else {
    
                    $row['tipologia'] .= ' (presenza)';
    
                    $onclick = "window.open('?contratti[id]=".$_REQUEST[ $ct['form']['table'] ]['id']."&__lezione__=".$row['id_todp']."&__assente__=".$row['id']."','_self');";
                    $buttons .= '<button type="button" class="button btn btn-secondary btn-xsm" onclick="'.$onclick.'">segna assente</button>';
        
                }
    
            } else {
    
                if( $row['id_tipologia'] == 15 || $row['id_tipologia'] == 32 || $row['id_tipologia'] == 33 ) {
    
                    $onclick = "window.open('?contratti[id]=".$_REQUEST[ $ct['form']['table'] ]['id']."&__lezione__=".$row['id_todp']."&__attesa__=".$row['id']."','_self');";
                    $buttons .= '<button type="button" class="button btn btn-secondary btn-xsm" onclick="'.$onclick.'">metti in attesa</button>';
    
                } else {
    
                    $onclick = "window.open('?contratti[id]=".$_REQUEST[ $ct['form']['table'] ]['id']."&__lezione__=".$row['id_todp']."&__frequenza__=".$row['id']."','_self');";
                    $buttons .= '<button type="button" class="button btn btn-secondary btn-xsm" onclick="'.$onclick.'">ammetti alla frequenza</button>';
    
                }
    
                $onclick = "window.open('?contratti[id]=".$_REQUEST[ $ct['form']['table'] ]['id']."&__lezione__=".$row['id_todp']."&__rimuovi__=".$row['id']."','_self');";
                $buttons .= '<button type="button" class="button btn btn-secondary btn-xsm" onclick="'.$onclick.'">rimuovi</button>';
    
            }
    
            $row[ NULL ] = $buttons;
    
        }
    }
    