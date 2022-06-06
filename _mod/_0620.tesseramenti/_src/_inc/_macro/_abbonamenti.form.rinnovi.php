<?php

    /**
     * macro view archivio contratti
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella della vista
    $ct['view']['table'] = 'rinnovi';

    $ct['form']['table'] = 'contratti';

    $ct['view']['open']['page'] = 'rinnovi.contratti.form';
    $ct['view']['open']['table'] = 'rinnovi';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
    $ct['view']['insert']['page'] = 'rinnovi.contratti.form';
    $ct['view']['insert']['field'] = 'id_contratto';

    // campo per il preset di apertura
    $ct['view']['open']['preset']['field'] = 'id_contratto';

    // campi della vista
    $ct['view']['cols'] = array(
      'id' => '#',
      'data_inizio' => 'data inizio',
      'data_fine' => 'data fine',
      'tipologia' => 'tipologia',
        'id_contratto' => 'id_contratto',
      '__label__' => 'contratto'
    );

    // stili della vista
    $ct['view']['class'] = array(
      'id_contratto' => 'd-none',
      '__label__' => 'text-left no-wrap'
    );

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
      // preset filtro contratto attuale
      $ct['view']['__restrict__']['id_contratto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    $ct['etc']['include']['insert'][] = array(
      'name' => 'rinnovi',
      'file' => 'inc/contratti.form.rinnovi.insert.html',
      'fa' => 'fa-plus-circle'
    );

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';
