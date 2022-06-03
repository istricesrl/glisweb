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
	$ct['form']['table'] = 'documenti_articoli';

    // tendina articoli
	$ct['etc']['select']['id_articoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM articoli_view'
	);

    // tendina tipologie anagrafica
	$ct['etc']['select']['tipologie_documenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_documenti_view'
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
	    'SELECT id, __label__ FROM mastri_view WHERE id_tipologia = 1'
	);

    // tendina valute
	$ct['etc']['select']['id_valute'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM valute_view '
	);

	// tendina reparti
	$ct['etc']['select']['id_reparti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM reparti_view '
	);



	// tendina progetti
	$ct['etc']['select']['id_progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM progetti_view '
	);

	// tendina todo
	$ct['etc']['select']['id_todo'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM todo_view '
	);

	// tendina matricole
	$ct['etc']['select']['matricole'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM matricole_view '
	);

        // tendina tipologie anagrafica
	$ct['etc']['select']['tipologie_documenti_articoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_documenti_view'
	);

    // tendina mittenti
	$ct['etc']['select']['id_emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_gestita = 1'
	);

    // tendina destinatari
	$ct['etc']['select']['id_destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static '
	);

	$ct['etc']['select']['id_documenti'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM documenti_view '
    );
    
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_documento'] )  && !empty( $_REQUEST[ $ct['form']['table'] ]['id_documento'] ) ){
		$documento = $_REQUEST[ $ct['form']['table'] ]['id_documento'];
	} elseif( isset( $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_documento'] ) ) {
		$documento = $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_documento'];
		$riga = mysqlSelectRow($cf['mysql']['connection'],'SELECT * FROM documenti WHERE id = ?', array( array( 's' => $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_documento'] ) ));
		$_REQUEST['__preset__'][ $ct['form']['table'] ]['id_documento'] = $riga['id'];
		$_REQUEST['__preset__'][ $ct['form']['table'] ]['id_emittente'] = $riga['id_emittente'];
		$_REQUEST['__preset__'][ $ct['form']['table'] ]['id_destinatario'] = $riga['id_destinatario'];
	} elseif(  isset( $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_genitore'] ) ) {
		$riga = mysqlSelectRow($cf['mysql']['connection'],'SELECT * FROM documenti_articoli WHERE id = ?', array( array( 's' => $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_genitore'] ) ));
		$documento =  $riga['id_documento'];
		$_REQUEST['__preset__'][ $ct['form']['table'] ]['id_documento'] = $riga['id_documento'];
		$_REQUEST['__preset__'][ $ct['form']['table'] ]['id_emittente'] = $riga['id_emittente'];
		$_REQUEST['__preset__'][ $ct['form']['table'] ]['id_destinatario'] = $riga['id_destinatario'];
	} elseif( isset( $_SESSION['__latest__'][ $ct['form']['table'] ]['id_documento'] ) ) {
		$documento = $_SESSION['__latest__'][ $ct['form']['table'] ]['id_documento'];
	} else {
		$documento = 'ALL';
	}

	if( $documento == 'ALL' && isset(  $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
		$ct['etc']['select']['id_righe_genitori'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM documenti_articoli_view WHERE id_genitore IS NULL AND id <> ?',
			array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
		);
		
	} elseif( isset(  $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {

	$ct['etc']['select']['id_righe_genitori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM documenti_articoli_view WHERE id_documento = ? AND id_genitore IS NULL AND id <> ?',
		array( array( 's' => $documento ), array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
    );

	}

	if( $documento != 'ALL'){
	$ct['etc']['id_emittente'] = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT id_emittente FROM documenti WHERE id = ? ',
		array( array( 's' => $documento ) )
    );

	$ct['etc']['id_destinatario'] = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT id_destinatario FROM documenti WHERE id = ? ',
		array( array( 's' => $documento ) )
    );

	$ct['etc']['id_tipologia'] = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT id_tipologia FROM documenti WHERE id = ? ',
		array( array( 's' => $documento ) )
    );
	}

	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_genitore'] ) && !empty($_REQUEST[ $ct['form']['table'] ]['id_genitore']) ){
		$ct['page']['etc']['tabs'] = array_diff(
			$ct['page']['etc']['tabs'],
			['documenti.articoli.form.aggregate']
		);
	}


	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
