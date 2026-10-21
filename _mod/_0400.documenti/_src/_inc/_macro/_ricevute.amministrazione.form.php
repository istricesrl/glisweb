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
	
    // TODO le fatture di ciclo attivo devono poter essere emesse solo dalle aziende gestite
    /**
     * tendina id_emittenti — disattivata il 2026-10-12, il campo ha gia' la ricerca REST
     *
     * Era `SELECT id, __label__ FROM anagrafica_view_static` senza WHERE. Su un deploy con l'anagrafica
     * grande ( Polmasi: oltre 55.000 righe ) supera il tetto di 1 MB di memcached, quindi la scrittura
     * in cache fallisce con l'errore 37 e la query si rifa' a ogni apertura del form ( Polmasi, ottobre
     * 2026: 239 scritture fallite, quasi tutte da questo form e dal suo gemello ).
     *
     * Non serviva. Il campo e' reso da `frm.selectBox()` con l'api `anagrafica`
     * ( _src/_templates/_athena/ricevute.amministrazione.form.html ): quando la macro riceve un `api` NON stampa
     * nemmeno le `<option>` — rende un hidden e lascia cercare via REST a
     * `_src/_js/_lib/_selectbox.js` da tre caratteri in su, e l'etichetta del valore gia' scelto
     * la prende da `/api/anagrafica/<id>`. La lista serviva al piu' a risolvere quell'etichetta.
     */
    $ct['etc']['select']['id_emittenti'] = array();

	// tendina coupon
	$ct['etc']['select']['coupon'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM coupon_view'
	);

    /**
     * tendina id_destinatari — disattivata il 2026-10-12, il campo ha gia' la ricerca REST
     *
     * Era `SELECT id, __label__ FROM anagrafica_view_static` senza WHERE. Su un deploy con l'anagrafica
     * grande ( Polmasi: oltre 55.000 righe ) supera il tetto di 1 MB di memcached, quindi la scrittura
     * in cache fallisce con l'errore 37 e la query si rifa' a ogni apertura del form ( Polmasi, ottobre
     * 2026: 239 scritture fallite, quasi tutte da questo form e dal suo gemello ).
     *
     * Non serviva. Il campo e' reso da `frm.selectBox()` con l'api `anagrafica`
     * ( _src/_templates/_athena/ricevute.amministrazione.form.html ): quando la macro riceve un `api` NON stampa
     * nemmeno le `<option>` — rende un hidden e lascia cercare via REST a
     * `_src/_js/_lib/_selectbox.js` da tre caratteri in su, e l'etichetta del valore gia' scelto
     * la prende da `/api/anagrafica/<id>`. La lista serviva al piu' a risolvere quell'etichetta.
     */
    $ct['etc']['select']['id_destinatari'] = array();

    // tendina indirizzi mittenti
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) ){
	    $ct['etc']['select']['id_sedi_emittente'] = tendinaSediAnagrafica( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] );
    } 

	// tendina indirizzi destinatari
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] ) ){
	    $ct['etc']['select']['id_sedi_destinatario'] = tendinaSediAnagrafica( $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] );
	   
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
