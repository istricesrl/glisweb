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

    // debug
    // die( print_r( $_REQUEST, true ) );

    // ...
    $idIscritto = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT id_anagrafica FROM contratti_anagrafica WHERE id_contratto = ? AND id_ruolo IN ( 29, 32, 33, 34 )',
        array(
            array( 's' => $_REQUEST['contratti']['id'] )
        )
    );

    // debug
    // die( 'iscritto: ' . $idIscritto );

    // gestione iscrizioni
    if( isset( $_REQUEST['__iscrivi__'] ) ) {

        // carico i dati della lezione
        $ct['lezione'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT __report_lezioni_corsi__.*
                FROM __report_lezioni_corsi__
                WHERE __report_lezioni_corsi__.id = ?
            ',
            array(
                array( 's' => $_REQUEST['__iscrivi__'] )
            )
        );

        // debug
        // die( print_r( $ct['lezione'], true ) );

        // verifico la disponibilità di posti
        if( $ct['lezione']['numero_alunni'] < $ct['lezione']['numero_posti'] ) {
            $idTipologia = 15;
        } else {
            $idTipologia = 40;
        }

        // debug
        // die( 'tipologia: ' . $idTipologia );

        // inserisco la prenotazione
        $ct['id_attivita'] = mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id_tipologia' => $idTipologia,
                'id_todo' => $_REQUEST['__iscrivi__'],
                'id_anagrafica' => $idIscritto,
                'id_contratto' => $_REQUEST['contratti']['id']
            ),
            'attivita',
            true,
            false,
            array(
                'id_tipologia',
                'id_todo',
                'id_anagrafica'
            )
        );

        // aggiorno il report delle lezioni
        updateReportLezioniCorsi( $_REQUEST['__iscrivi__'] );
        updateAttivitaViewStatic( $ct['id_attivita'] );

        // debug
        // die( 'attività: ' . $ct['id_attivita'] );

    }

    // gestisco la prenotazione
    if( isset( $_REQUEST['__cancella__'] ) ) {

        // elimino la prenotazione
        mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM attivita WHERE id_todo = ? AND id_anagrafica = ?',
            array(
                array( 's' => $_REQUEST['__cancella__'] ),
                array( 's' => $idIscritto )
            )
        );

        // aggiorno il report delle lezioni
        updateReportLezioniCorsi( $_REQUEST['__cancella__'] );
        // cleanAttivitaViewStatic( $_REQUEST['__cancellazione__']['id_frequenza'] );
        cleanAttivitaViewStatic();

    }

    // tabella gestita
	$ct['form']['table'] = 'contratti';

    // tabella della vista
    $ct['view']['data']['__report_mode__'] = 1;
    $ct['view']['table'] = '__report_lezioni_corsi__';

    // pagina per la gestione degli oggetti esistenti
	// $ct['view']['open']['page'] = 'presenze.form';
	$ct['view']['open']['page'] = 'lezioni.form';
	$ct['view']['open']['table'] = 'todo';

     // campi della vista
     $ct['view']['cols'] = array(
	    'id' => '#',
        'tipologia' => 'tipologia',
//        'cliente' => 'cliente',
        'data_programmazione' => 'data',
        'ora_inizio_programmazione' => 'ora',
//        'ora_fine_programmazione' => 'ora fine',
        'note_programmazione' => 'ora',
        'id_progetto' => 'ID corso',
        'corso' => 'corso',
        'discipline' => 'disciplina',
        'luogo' => 'luogo',
        'posti_disponibili' => 'posti',
//        'anagrafica_programmazione' => 'assegnata a',
//        'data_programmazione' => 'data',
//	    'anagrafica' => 'svolta da',
/*        'nome' => 'attività',
	    'ore' => 'ore',
        'ora_inizio' => 'oi',
        'ora_fine' => 'of' */
        NULL => 'azioni'
      );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left',
        'cliente' => 'text-left d-none d-md-table-cell',
        'anagrafica_programmazione' => 'text-left',
        'id_progetto' => 'd-none',
        'corso' => 'text-left',
        'discipline' => 'text-left',
	    'data_programmazione' => 'no-wrap',
        'ora_inizio_programmazione' => 'd-none',
        'ora_fine_programmazione' => 'd-none',
        'note_programmazione' => 'd-none',
//        'data_attivita' => 'no-wrap',
	    'anagrafica' => 'text-left no-wrap',
        'luogo' => 'text-left',
        'nome' => 'text-left',
        'ora_inizio' => 'd-none',
        'ora_fine' => 'd-none',
        NULL => 'no-wrap'
    );

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    // ordinamento di default
    $ct['view']['__sort__']['data_programmazione']	= 'ASC';
    $ct['view']['__sort__']['ora_inizio_programmazione']	= 'ASC';

    // filtri di default
    $ct['view']['__filters__']['data_programmazione']['GE'] = date( 'Y-m-d' );
    $ct['view']['__filters__']['data_programmazione']['LE'] = date( 'Y-m-d', strtotime( '+1 month' ) );

    // preset filtro custom progetti aperti
    $ct['view']['__restrict__']['id_tipologia']['EQ'] = 15;
    // TODO decommentare, l'ho commentato per i test $ct['view']['__restrict__']['data_programmazione']['GE'] = date( 'Y-m-d' );

    /**
     * TODO IMPORTANTE aggiungere al report lezioni un campo con gli abbonamenti compatibili su cui fare LIKE (ad es [1],[3])
     * 
     * TODO ricavare le date di validità dell'abbonamento e i periodi di sospensione e aggiungerli come __restrict__ aggiuntivi
     * 
     * TODO aggiungere __restrict__ per le lezioni che iniziano fra meno di tot ore, ecc. come da app
     * 
     */

    // debug
    // die( print_r( $_REQUEST, true ) );
    // die( print_r( $ct['view'], true ) );
    // die( print_r( $orari, true ) );

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/lezioni.view.filters.html';

    /*
    // tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][$mese] =  int2month( $mese ) ;
	}

    // tendina anni
	foreach( range( date( 'Y' ) - 5,  date( 'Y' ) ) as $y ) {
	    $ct['etc']['select']['anni'][$y] = $y ;
	}

    // tendina mesi
    $start = '2024-01-01';
    for( $i = 0; $i < 12; $i++ ){
        $ct['etc']['select']['mesi'][] = array(
            'id' => date( 'Y-m-01', strtotime( $start ) ) . '|' . date( 'Y-m-t', strtotime( $start ) ),
            '__label__' => date( 'Y-m-01', strtotime( $start ) ) . ' / ' . date( 'Y-m-t', strtotime( $start ) )
        );
        $start = date( 'Y-m-01', strtotime( $start . ' +1 month' ) );
    }
    */

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

    // tendina tipologie attività
	$ct['etc']['select']['corsi'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM corsi_view WHERE data_chiusura > now() ORDER BY __label__');

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( !empty( $ct['view']['data'] ) ) {
		foreach ( $ct['view']['data'] as &$row ) {

            $iscritto = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT count(*) FROM attivita WHERE id_todo = ? AND id_anagrafica = ?',
                array(
                    array( 's' => $row['id'] ),
                    array( 's' => $idIscritto )
                )
            );

            $buttons = '';

            if( ! empty( $iscritto ) ) {
                $onclick = "$('#form-contratti').attr('action','?contratti[id]=".$_REQUEST[ $ct['form']['table'] ]['id']."&__cancella__=".$row['id']."'); $('#form-contratti').submit();";
                $buttons .= '<a href="#" data-toggle="modal" data-target="#archivia_attivita" onclick="'.$onclick.'"><i class="fa fa-calendar-minus-o"></i></a>';
            } else {
                $onclick = "$('#form-contratti').attr('action','?contratti[id]=".$_REQUEST[ $ct['form']['table'] ]['id']."&__iscrivi__=".$row['id']."'); $('#form-contratti').submit();";
                $buttons .= '<a href="#" data-toggle="modal" data-target="#archivia_attivita" onclick="'.$onclick.'"><i class="fa fa-graduation-cap"></i></a>';
            }

            $row[ NULL ] = $buttons;

        }
	}
