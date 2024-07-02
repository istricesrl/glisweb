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
	$ct['form']['table'] = 'liste';

    // tabella della vista
	$ct['view']['table'] = 'liste_mail';

    // id della vista
   	# $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'liste.mail.form';
    $ct['view']['open']['table'] = 'liste_mail';
    $ct['view']['open']['field'] = 'id';

	// pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'liste.mail.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_lista';

	$ct['view']['cols'] = array(
        'id' => '#',
#        'tipologia' => 'tipologia',
#        'data' => 'data',
#        'nome' => 'nome',
#		'id_articolo' => 'articolo',
#		'mastro_provenienza' => 'scarico',
#		'mastro_destinazione' => 'carico',
#        'quantita' => 'quantità',
#        'importo_netto_totale' => 'importo netto',
#		'id_genitore' => 'aggregata a',
#		'id_documento' => 'id_documento'
		'anagrafica' => 'destinatario',
		'mail' => 'indirizzo'
#		'data_ora_generazione' => 'preparata',
#		'data_ora_invio' => 'inviata'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'importo_netto_totale' => 'text-right',
        'quantita' => 'text-right',
		'totale_riga' => 'text-right',
        'id_documento' => 'd-none',
        'cliente' => 'text-left',
        'emittente' => 'text-left', 
        'data' => 'no-wrap', 
        'anagrafica' => 'text-left',
		'mail' => 'text-left'
    );

	// preset filtro righe documento
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
		$ct['view']['__restrict__']['id_lista']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	}

	$ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/liste.form.stati.insert.html',
        'fa' => 'fa-plus-circle'
    );

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
