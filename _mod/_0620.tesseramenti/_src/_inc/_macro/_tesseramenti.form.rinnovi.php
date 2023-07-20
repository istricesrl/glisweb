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

    $ct['form']['table'] = 'contratti';

    // tabella della vista
    $ct['view']['table'] = 'rinnovi';

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

    $ct['etc']['include']['insert'][] = array(
      'name' => 'insert',
      'file' => 'inc/tesseramenti.form.rinnovi.insert.html',
      'fa' => 'fa-plus-circle'
    );

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
      // preset filtro contratto attuale
      $ct['view']['__restrict__']['id_contratto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    // tendina tipologia tesseramento
    $ct['etc']['select']['tipologie_rinnovi'] = mysqlCachedIndexedQuery(
      $cf['memcache']['index'],
      $cf['memcache']['connection'],
      $cf['mysql']['connection'],
      'SELECT id, __label__ FROM tipologie_rinnovi_view WHERE se_tesseramenti = 1'
    );

    $ct['etc']['select']['materie'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM categorie_progetti_view WHERE se_disciplina = 1'
    );

    // inizio e fine
    $ct['etc']['periodo'] = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT periodi.* FROM periodi INNER JOIN tipologie_periodi ON tipologie_periodi.id = periodi.id_tipologia WHERE periodi.data_fine > date( now() ) AND ( tipologie_periodi.se_tesseramenti IS NOT NULL ) ORDER BY periodi.data_fine ASC'
    );

    // debug
    // die( print_r( $ct['etc']['periodo'], true ) );

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';
