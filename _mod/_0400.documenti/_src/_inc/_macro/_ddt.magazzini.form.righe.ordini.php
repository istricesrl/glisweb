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
	$ct['view']['table'] = 'documenti_articoli';

    // id della vista
   	// $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'righe.ddt.magazzini.form';
    $ct['view']['open']['table'] = 'documenti_articoli';
    $ct['view']['open']['field'] = 'id';

	// pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'righe.ddt.magazzini.form';
	$ct['view']['insert']['field'] = 'id_documento';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_documento';

	$ct['view']['cols'] = array(
        'id' => '#',
#        'tipologia' => 'tipologia',
#        'data' => 'data',
#        'nome' => 'nome',
		'id_articolo' => 'codice',
		'articolo' => 'articolo',
		'mastro_provenienza' => 'scarico',
		'mastro_destinazione' => 'carico',
        'quantita' => 'quantità',
	#	'totale_riga' => 'totale',
		'id_documento' => 'id_documento'
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
		'articolo' => 'text-left'
    );

	// RELAZIONI CON IL MODULO MATRICOLE
	if( in_array( "4110.matricole", $cf['mods']['active']['array'] ) ) {

		// colonna matricola
		arrayInsertAssoc( 'id_articolo', $ct['view']['cols'], array( 'matricola' => 'matricola' ) );

		// OPZIONE scadenze
		if( ! empty( $cf['matricole']['scadenze'] ) ) {
			arrayInsertAssoc( 'matricola', $ct['view']['cols'], array( 'data_scadenza' => 'scadenza' ) );
		}

	}

    $ct['etc']['include']['insert'] = 'inc/ddt.magazzini.form.righe.insert.html';

	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
		// preset filtro custom progetti aperti
		$ct['view']['__restrict__']['id_documento']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	}


    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	///foreach( $ct['view']['data'] as &$row ) {
	//}

    // macro di default per l'entità DDT
	require DIR_BASE . '_mod/_0400.documenti/_src/_inc/_macro/_ddt.magazzini.form.default.php';

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
