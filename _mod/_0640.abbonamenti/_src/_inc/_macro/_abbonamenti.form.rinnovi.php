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
    $ct['etc']['select']['tipologie_rinnovi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_rinnovi_view'
    );

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
      'name' => 'rinnovi',
      'file' => 'inc/abbonamenti.form.rinnovi.insert.html',
      'fa' => 'fa-plus-circle'
    );

   // gestione default
   require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';
