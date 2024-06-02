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

     // 
    $ct['form']['table'] = 'contratti';

	// tendina per le tipologie di contratto
    $ct['etc']['select']['tipologie_periodi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_periodi_view WHERE id = 5 OR id_genitore = 5'
    );

    // debug
    // die( print_r( $ct['etc']['select']['tipologie_periodi'], true ) );

    // tabella della vista
    $ct['view']['table'] = 'periodi';

    $ct['view']['open']['page'] = 'periodi.contratti.form';
    $ct['view']['open']['table'] = 'periodi';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
    $ct['view']['insert']['page'] = 'periodi.contratti.form';
    $ct['view']['insert']['field'] = 'id_contratto';

    // campo per il preset di apertura
    $ct['view']['open']['preset']['field'] = 'id_contratto';

    // campi della vista
    $ct['view']['cols'] = array(
      'id' => '#',
      'data_inizio' => 'data inizio',
      'data_fine' => 'data fine',
        'id_contratto' => 'id_contratto',
        '__label__' => 'descrizione'
    );

    // stili della vista
    $ct['view']['class'] = array(
      'id_contratto' => 'd-none',
      '__label__' => 'text-left no-wrap'
    );

    // preset filtro contratto attuale
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {
    $ct['view']['__restrict__']['id_contratto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    $ct['etc']['include']['insert'][] = array(
      'name' => 'sospensioni',
      'file' => 'inc/abbonamenti.form.sospensioni.insert.html',
      'fa' => 'fa-plus-circle'
    );

   // gestione default
   require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';
