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
	    'SELECT id, __label__ FROM tipologie_documenti_view'
	);

	// tendina condizioni_pagamento
	$ct['etc']['select']['condizioni_pagamento'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM condizioni_pagamento_view'
	);
	
    // tendina mittenti
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
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) ){
	    $ct['etc']['select']['id_sedi_emittente'] = mysqlCachedIndexedQuery(
	        $cf['memcache']['index'],
	        $cf['memcache']['connection'],
	        $cf['mysql']['connection'],
	        'SELECT indirizzi_view.id, __label__ FROM indirizzi_view LEFT JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id_indirizzo = indirizzi_view.id WHERE anagrafica_indirizzi.id_anagrafica = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) )
	    );
    } else {
		$_REQUEST[ $ct['form']['table'] ]['id_emittente'] = trovaIdAziendaGestita();
	}

	// tendina indirizzi destinatari
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] ) ){
	    $ct['etc']['select']['id_sedi_destinatario'] = mysqlCachedIndexedQuery(
	        $cf['memcache']['index'],
	        $cf['memcache']['connection'],
	        $cf['mysql']['connection'],
	        'SELECT indirizzi_view.id, __label__ FROM indirizzi_view LEFT JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id_indirizzo = indirizzi_view.id  WHERE anagrafica_indirizzi.id_anagrafica = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] ) )
	    );
	}

	if( isset( $_REQUEST['__ordine_da_evadere__'] ) ){

		$ct['etc']['ordine'] = mysqlSelectRow(
	        $cf['mysql']['connection'],
	        'SELECT * FROM documenti WHERE id = ? ',
            array( array( 's' => $_REQUEST['__ordine_da_evadere__'] ) )
	    );
	}

	// macro di default per l'entità DDT
	require DIR_BASE . '_mod/_0400.documenti/_src/_inc/_macro/_ddt.magazzini.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
