<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
    $ct['view']['table'] = 'pagamenti';

    /*
    // id della vista
    $ct['view']['id'] = md5(
        $ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__'] .
        ( ( isset( $ct['form']['table'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) ? $_REQUEST[ $ct['form']['table'] ]['id'] : NULL )
    );
    */
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'pagamenti.amministrazione.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_scadenza' => 'scadenza',
		'documento' => 'documento',
        'nome' => 'nome',
        'emittente' => 'da',
        'destinatario' => 'a',
		'id_tipologia_documento' => 'id_tipologia_documento',
#		'mastro_destinazione' => 'carico',
        'modalita_pagamento' => 'modalità',
        'importo_lordo_totale' => 'importo',
        'data_ora_pagamento' => 'pagato'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id_tipologia_documento' => 'd-none',
        'nome' => 'text-left',
        'documento' => 'text-left',
        'numero' => 'text-left',
        'data_scadenza' => 'no-wrap',
        'data_ora_pagamento' => 'no-wrap',
        '__label__' => 'text-left',
        'destinatario' => 'text-left',
        'emittente' => 'text-left',
        'destinatario' => 'text-left',
        'tipologia' => 'text-left',
        'importo_lordo_totale' => 'text-right' 
    );

	// RELAZIONI CON IL MODULO MASTRI
	if( in_array( "0500.mastri", $cf['mods']['active']['array'] ) ) {
		arrayInsertAssoc( 'nome', $ct['view']['cols'], array( 'mastro_provenienza' => 'scarico', 'mastro_destinazione' => 'carico' ) );
	}

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/pagamenti.view.filters.html';

    // tendina tipologie
	$ct['etc']['select']['tipologie_documenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_documenti_view'
	);
/*
    // tendina mittenti
	$ct['etc']['select']['id_emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_gestita = 1 ORDER BY __label__'
	);

    // tendina destinatari
	$ct['etc']['select']['id_destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static ORDER BY __label__'
	);
*/
    // tendina aziende
	$ct['etc']['select']['aziende'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_gestita = 1 ORDER BY __label__'
	);

    // tendina tipologie
	$ct['etc']['select']['modalita_pagamento'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM modalita_pagamento_view'
	);


/*
    if( isset( $_REQUEST['__view__'] ) && isset( $ct['view']['id'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_tipologia_documento']['EQ'] )  ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_tipologia_documento']['EQ'] = 1;
    }
*/
/*
    if( isset( $_REQUEST['__view__'] ) && isset( $ct['view']['id'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['timestamp_pagamento']['NL'] ) ) {
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['timestamp_pagamento']['NL'] = 1;
    }
*/
    $ct['view']['__filters__']['timestamp_pagamento']['NL'] = 1;

/*
    if( isset( $_REQUEST['__view__'] ) && isset( $ct['view']['id'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_emittente']['EQ'] )  ) {
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_emittente']['EQ'] = trovaIdAziendaGestita();
    }
*/
/*
    if( isset( $_REQUEST['__view__'] ) && isset( $ct['view']['id'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_emittente|id_destinatario']['EQ'] ) ) {
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_emittente|id_destinatario']['EQ'] = trovaIdAziendaGestita();
    }
*/

    $ct['view']['__filters__']['id_emittente|id_destinatario']['EQ'] = trovaIdAziendaGestita();

    // filtri di default
    $ct['view']['__filters__']['data_scadenza']['GE'] = date( 'Y-m-d' );
    $ct['view']['__filters__']['data_scadenza']['LE'] = date( 'Y-m-d', strtotime( '+1 month' ) );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // debug
    // die( print_r( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__'], true ) );
