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
        'id_tipologia' => 'ID tipologia',
        'tipologia' => 'tipologia',
        'data_attivita' => 'data attività',
//        'data_inizio' => 'data inizio',
//        'data_fine' => 'data fine',
        NULL => 'azioni'
    );
    
    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'd-none',
        'id_tipologia' => 'd-none',
        'data_attivita' => 'd-none',
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
/*
    // tendina abbonamenti
    $ct['etc']['select']['id_contratto'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM contratti_view WHERE id_tipologia = 1'
    );
*/
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
    $ct['view']['__restrict__']['id_tipologia']['IN'] = '15|19|32|33|40';

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
        updateReportLezioniCorsi( $_REQUEST[ $ct['form']['table'] ]['id'] );
        updateAttivitaViewStatic( $_REQUEST['__frequenza__'] );
    } elseif( isset( $_REQUEST['__presente__'] ) && ! empty( $_REQUEST['__presente__'] ) ) {
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET data_attivita = ?, id_tipologia = 15 WHERE id = ?',
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['data_programmazione'] ),
                array( 's' => $_REQUEST['__presente__'] )
            )
        );
        updateReportLezioniCorsi( $_REQUEST[ $ct['form']['table'] ]['id'] );
        updateAttivitaViewStatic( $_REQUEST['__presente__'] );
    } elseif( isset( $_REQUEST['__assente__'] ) && ! empty( $_REQUEST['__assente__'] ) ) {
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET data_attivita = NULL, id_tipologia = 19 WHERE id = ?',
            array(
                array( 's' => $_REQUEST['__assente__'] )
            )
        );
        updateReportLezioniCorsi( $_REQUEST[ $ct['form']['table'] ]['id'] );
        updateAttivitaViewStatic( $_REQUEST['__assente__'] );
    }

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';

    // ...
    // if( isset( $_REQUEST['__recupero__'] ) ) {
    if( isset( $_SESSION['__work__']['recuperi']['items'] ) ) {

        // ...
        $recupero = reset( $_SESSION['__work__']['recuperi']['items'] );
        $idRecupero = $recupero['id'];

        $recupero = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM attivita WHERE id = ?',
            array(
                array( 's' => $idRecupero )
            )
        );

        // die( print_r( $recupero, true ) );

        $ct['etc']['defaults']['id_genitore'] = $idRecupero;
        $ct['etc']['defaults']['id_anagrafica'] = $recupero['id_anagrafica'];
        $ct['etc']['defaults']['id_tipologia'] = 32;

        unset( $_SESSION['__work__']['recuperi'] );

    } else {

        $ct['etc']['defaults']['id_tipologia'] = 15;

    }

/*
    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){

        if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_inizio']['GE'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_fine']['LE'] ) ) {
            $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_inizio']['GE'] = $_REQUEST[ $ct['form']['table'] ]['data_accettazione'];
            $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_fine']['LE'] = $_REQUEST[ $ct['form']['table'] ]['data_chiusura'];
        }

    }


*/

if( !empty( $ct['view']['data'] ) ){
    foreach ( $ct['view']['data'] as &$row ){

        $buttons = '';

        if( $_REQUEST[ $ct['form']['table'] ]['data_programmazione'] < date('Y-m-d') ){

            if( empty( $row['data_attivita'] ) ) {

                $onclick = "window.open('?todo[id]=".$_REQUEST[ $ct['form']['table'] ]['id']."&__presente__=".$row['id']."','_self');";
                $buttons .= '<button type="button" class="button btn btn-secondary btn-xsm" onclick="'.$onclick.'">segna presente</button>';
    
            } else {

                $row['tipologia'] .= ' (presenza)';

                $onclick = "window.open('?todo[id]=".$_REQUEST[ $ct['form']['table'] ]['id']."&__assente__=".$row['id']."','_self');";
                $buttons .= '<button type="button" class="button btn btn-secondary btn-xsm" onclick="'.$onclick.'">segna assente</button>';
    
            }

        } else {

            if( $row['id_tipologia'] == 15 || $row['id_tipologia'] == 32 || $row['id_tipologia'] == 33 ) {

                $onclick = "window.open('?todo[id]=".$_REQUEST[ $ct['form']['table'] ]['id']."&__attesa__=".$row['id']."','_self');";
                $buttons .= '<button type="button" class="button btn btn-secondary btn-xsm" onclick="'.$onclick.'">metti in attesa</button>';

            } else {

                $onclick = "window.open('?todo[id]=".$_REQUEST[ $ct['form']['table'] ]['id']."&__frequenza__=".$row['id']."','_self');";
                $buttons .= '<button type="button" class="button btn btn-secondary btn-xsm" onclick="'.$onclick.'">ammetti alla frequenza</button>';

            }

            $onclick = "window.open('?todo[id]=".$_REQUEST[ $ct['form']['table'] ]['id']."&__rimuovi__=".$row['id']."','_self');";
            $buttons .= '<button type="button" class="button btn btn-secondary btn-xsm" onclick="'.$onclick.'">rimuovi</button>';

        }

        $row[ NULL ] = $buttons;

    }
}
