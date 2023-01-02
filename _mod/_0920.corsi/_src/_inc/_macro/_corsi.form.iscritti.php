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
	$ct['form']['table'] = 'progetti';
    
    $ct['view']['etc']['__report_mode__'] = 1;
    $ct['view']['table'] = '__report_iscritti_corsi__';



    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/corsi.iscritti.view.filters.html';

    // campi della vista
    $ct['view']['cols'] = array(
        'id_progetto' => 'progetto',
        'anagrafica' => 'anagrafica',
        'data_inizio' => 'data inizio',
        'data_fine' => 'data fine'
    );
    
    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'd-none',
        'mastro' => 'text-left'
    );
    
  /*  $ct['view']['open']['page'] = 'contratti.form';
    $ct['view']['open']['table'] = 'contratti';
    $ct['view']['open']['field'] = 'id_contratto';*/


    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){

        // preset filtro custom progetti aperti
        $ct['view']['__restrict__']['id_progetto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }
    

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';
        
    if( isset($_REQUEST[ $ct['form']['table'] ]['id']) ){

        if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_inizio']['GE'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_fine']['LE'] ) ) {
            $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_inizio']['GE'] = $_REQUEST[ $ct['form']['table'] ]['data_accettazione'];
            $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_fine']['LE'] = $_REQUEST[ $ct['form']['table'] ]['data_chiusura'];
        }
    }