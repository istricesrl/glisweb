<?php

    /**
     * macro form anagrafica
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
	$ct['form']['table'] = 'documenti';


    // tabella della vista
	$ct['view']['table'] = 'attivita';

    // id della vista
   # $ct['view']['id'] = md5( $ct['view']['table'] );

        // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'attivita.form';
    $ct['view']['open']['table'] = 'attivita';
    $ct['view']['open']['field'] = 'id';

	// pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'attivita.form';
	$ct['view']['insert']['field'] = 'id_documento';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_documento';

	$ct['view']['cols'] = array(
        'id' => '#',
        'data_attivita' => 'data',
        'tipologia' => 'tipologia',
		'id_documento' => 'id_documento',
        'nome' => 'nome'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'quantita' => 'text-right',
		'totale_riga' => 'text-right',
        'id_documento' => 'd-none',
        'cliente' => 'text-left',
        'emittente' => 'text-left', 
        'data' => 'no-wrap', 
#        'tipologia' => 'text-left',
		'id_articolo' => 'text-left'
    );

#	$ct['etc']['include']['insert'] = 'inc/ddt.passivi.magazzini.form.righe.insert.html';

	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
		// preset filtro custom progetti aperti
		$ct['view']['__restrict__']['id_documento']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	}

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	///foreach( $ct['view']['data'] as &$row ) {
	//}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

/*
    // tendina articoli
	$ct['etc']['select']['id_articoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM articoli_view'
	);

    // tendina udm
	$ct['etc']['select']['id_udm'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM udm_view'
	);

    // tendina iva
	$ct['etc']['select']['id_iva'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM iva_view '
	);

	// tendina listini
	$ct['etc']['select']['id_listini'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM listini_view '
	);

	// tendina mastri
	$ct['etc']['select']['id_mastri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mastri_view '
	);

	// tendina progetti
	$ct['etc']['select']['id_progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM progetti_view '
	);
*/
