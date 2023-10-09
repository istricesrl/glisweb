<?php

    /**
     * macro form progetti
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
	$ct['form']['table'] = 'todo';
    
    $ct['view']['table'] = 'attivita';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
//        'id_todo' => 'iscrizione',
        'anagrafica' => 'iscritto',
        'tipologia' => 'tipologia',
//        'data_inizio' => 'data inizio',
//        'data_fine' => 'data fine',
        NULL => 'azioni'
    );
    
    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'd-none',
        'anagrafica' => 'text-left',
        NULL => 'nowrap'
    );

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    // ...
	$ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/lezioni.form.presenze.insert.html',
        'fa' => 'fa-plus-circle'
    );

    // tendina collaboratori
	$ct['etc']['select']['id_anagrafica'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static'
    );

    // tendina tipologie
    $ct['etc']['select']['id_tipologia'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL ORDER BY __label__'
    );

    // ...
    // $ct['view']['open']['page'] = 'iscrizioni.form';
    // $ct['view']['open']['table'] = 'contratti';
    // $ct['view']['open']['field'] = 'id_contratto';

    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){

        // preset filtro custom progetti aperti
        $ct['view']['__restrict__']['id_todo']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    }

    // preset filtro custom progetti aperti
    $ct['view']['__restrict__']['id_tipologia']['IN'] = '15|19|32|33';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';

/*
    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){

        if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_inizio']['GE'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_fine']['LE'] ) ) {
            $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_inizio']['GE'] = $_REQUEST[ $ct['form']['table'] ]['data_accettazione'];
            $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_fine']['LE'] = $_REQUEST[ $ct['form']['table'] ]['data_chiusura'];
        }

    }

if( !empty( $ct['view']['data'] ) ){
    foreach ( $ct['view']['data'] as &$row ){
         if(!empty($row['data_programmazione'])){
//                $row['data_attivita'] = date('d/m/Y', strtotime($row['data_attivita']));
            $row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione'])).' '.substr($row['ora_inizio_programmazione'],0,5);
        }
    }
}

*/
