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
	$ct['view']['table'] = 'contratti_anagrafica';

    // pagina per la gestione degli oggetti esistenti
	// $ct['view']['open']['page'] = 'contratti.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_anagrafica';

     // campi della vista
     $ct['view']['cols'] = array(
	    'id' => '#',
        'id_contratto' => '#',
        'data_inizio' => 'dal',
        'data_fine' => 'al',
        'tipologia' => 'tipologia'
      );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none',
	    'id_contratto' => 'd-none d-md-table-cell',
//	    'data' => 'text-left no-wrap'
    );

    /*
    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/anagrafica.form.attivita.insert.html',
        'fa' => 'fa-plus-circle'
    );

    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert_memo',
        'file' => 'inc/anagrafica.form.attivita.insert.promemoria.html',
        'fa' => 'fa-calendar-plus-o'
    );
    */

    // ...
	$ct['view']['open']['field'] = 'id_contratto';

    // ...
	$ct['view']['open']['table'] = 'contratti';

    /*
    $ct['etc']['select']['id_tipologia'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL ORDER BY __label__' );
    */

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'contratti.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'contratti.form';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){
        // preset filtro custom progetti aperti
	    $ct['view']['__restrict__']['id_anagrafica']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	    $ct['view']['__restrict__']['se_contraente']['EQ'] = 1;
    }

    // tendina tipologia attivita
	// $ct['etc']['id_tipologia_attivita'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, nome AS __label__ FROM tipologie_attivita WHERE se_agenda = 1 ORDER BY nome' );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';
	require DIR_SRC_INC_MACRO . '_default.form.php';
/*
    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['data'] ) ) {
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['data']	= 'DESC';
    } 

    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['sezionale'] ) ) {
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['sezionale']	= 'DESC';
    } 

    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['numero'] ) ) {
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['numero']	= 'DESC';
    }
*/
/*
    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
            if( !empty($row['data_programmazione']) && (!empty($row['ora_inizio_programmazione']) || !empty($row['ora_fine_programmazione']) )){ 
                $row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione']) ).'  '.( empty($row['ora_inizio_programmazione']) ? '  '  : date('H:i', strtotime($row['ora_inizio_programmazione']))).' &mdash; '.( empty($row['ora_fine_programmazione']) ? '  ' :date('H:i', strtotime($row['ora_fine_programmazione']) ));}
            elseif( !empty($row['data_programmazione']) ){$row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione']));}

            if( !empty( $row['data_attivita'] ) ){$row['data_attivita'] = date('d/m/Y', strtotime($row['data_attivita']));}
            if( !empty( $row['ora_inizio'] ) || !empty( $row['ora_fine'] ) ){ 
                $row['data_attivita'] = $row['data_attivita'].'  '.( empty($row['ora_inizio']) ? '  '  : date('H:i', strtotime($row['ora_inizio']))).' &mdash; '.( empty($row['ora_fine']) ? '  ' :date('H:i', strtotime($row['ora_fine']) ));
             }
          //s  $row['__label__'] = $row['note_interne'].( empty($row['note_interne']) ? '' : '; <br>').$row['testo'];
		}
	}
*/
