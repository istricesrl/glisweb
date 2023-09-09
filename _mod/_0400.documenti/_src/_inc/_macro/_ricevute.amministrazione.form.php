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

    // tendina tipologie anagrafica
	$ct['etc']['select']['tipologie_documenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_documenti_view WHERE se_ricevuta = 1'
	);

	// tendina condizioni_pagamento
	$ct['etc']['select']['condizioni_pagamento'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM condizioni_pagamento_view'
	);

	// esigibilità iva
	$ct['etc']['select']['esigibilita'] = array(
		array( 'id' => 'I', '__label__'=> 'I - immediata' ),
		array( 'id' =>'D', '__label__'=> 'D - differita' ),
		array( 'id' =>'S', '__label__'=> 'S - scissione dei pagamenti')
	); 
	
    // tendina mittenti
	// TODO le fatture di ciclo attivo devono poter essere emesse solo dalle aziende gestite
	$ct['etc']['select']['id_emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static' 
	);

	// tendina coupon
	$ct['etc']['select']['coupon'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM coupon_view'
	);

    // tendina destinatari
	$ct['etc']['select']['id_destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static'
	);

    // tendina indirizzi mittenti
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) ){
	    $ct['etc']['select']['id_sedi_emittente'] = mysqlCachedIndexedQuery(
	        $cf['memcache']['index'],
	        $cf['memcache']['connection'],
	        $cf['mysql']['connection'],
	        'SELECT indirizzi_view.id, __label__ FROM indirizzi_view LEFT JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id_indirizzo = indirizzi_view.id WHERE anagrafica_indirizzi.id_anagrafica = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) )
	    );
    } 

	// tendina indirizzi destinatari
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] ) ){
	    $ct['etc']['select']['id_sedi_destinatario'] = mysqlCachedIndexedQuery(
	        $cf['memcache']['index'],
	        $cf['memcache']['connection'],
	        $cf['mysql']['connection'],
	        'SELECT indirizzi_view.id, __label__ FROM indirizzi_view LEFT JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id_indirizzo = indirizzi_view.id  WHERE anagrafica_indirizzi.id_anagrafica = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] ) )
	    );
	   
		/*$ct['etc']['tipologia_anagrafica'] = mysqlCachedIndexedQuery(
	        $cf['memcache']['index'],
	        $cf['memcache']['connection'],
	        $cf['mysql']['connection'],
	        'SELECT anagrafica.*, tipologie_anagrafica.se_pubblica_amministrazione FROM anagrafica LEFT JOIN tipologie_anagrafica ON tipologie_anagrafica.id = anagrafica.id_tipologia  WHERE anagrafica.id = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] ) )
	    );*/
		
	} 


	// TODO ma non dovrebbe essere trovaIdAziendaGestita()?
	if( !isset( $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_emittente'] ) && !isset( $_REQUEST['__latest__'][ $ct['form']['table'] ]['id_emittente'] ) && !empty( $ct['etc']['select']['id_emittenti'] ) ){
		$_REQUEST['__preset__'][ $ct['form']['table'] ]['id_emittente'] = $ct['etc']['select']['id_emittenti'][0]['id'];
	}

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
