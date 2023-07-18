<?php

    /**
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

    $ct['form']['subtable'] = 'contratti_anagrafica';

    // tendina tesserato
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
	);

	// tendina per le tipologie di contratto
    $ct['etc']['select']['tipologie_contratti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_contratti_view WHERE se_abbonamento = 1'
    );

    // tendina badge
	$ct['etc']['select']['badge'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM badge_view'
    );

    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM corsi_view '
    );

    // tendina categorie progetti
	$ct['etc']['select']['materie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_disciplina = 1'
	);

    // ID della scuola
	$ct['etc']['gestita'] = mysqlSelectCachedValue(
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id FROM anagrafica_view WHERE se_gestita = 1'
	);

	// debug
	// print_r( $_REQUEST[ $ct['form']['table'] ]['rinnovi'] );
	// print_r( $_REQUEST );

    // ...
    if( isset( $_REQUEST[ $ct['form']['table'] ]['rinnovi'] ) ) {
		arraySortBy( 'data_inizio', $_REQUEST[ $ct['form']['table'] ]['rinnovi'] );
		$ct['etc']['sub']['primo_rinnovo'] = array_shift( $_REQUEST[ $ct['form']['table'] ]['rinnovi'] );
	}

	// ...
	// $ct['etc']['sub']['primo_rinnovo']['idx'] = 0;

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
      'id_tipologia' => 'id_tipologia',
      'tipologia' => 'tipologia',
        'id_contratto' => 'id_contratto',
      '__label__' => 'contratto',
      NULL => 'azioni'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'id_tipologia' => 'd-none',
        'id_contratto' => 'd-none',
      '__label__' => 'text-left no-wrap'
    );

    // preset filtro contratto attuale
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        $ct['view']['__restrict__']['id_contratto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/tesseramenti.form.rinnovi.insert.html',
        'fa' => 'fa-plus-circle'
    );

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

	// debug
	// print_r( $ct['etc']['sub']['primo_rinnovo'] );
	// print_r( $_REQUEST );

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
