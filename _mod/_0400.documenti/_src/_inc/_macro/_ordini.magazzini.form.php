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

	/**
	 * tendina id_emittenti — disattivata il 2026-10-12, il campo ha gia' la ricerca REST
	 *
	 * Era `SELECT id, __label__ FROM anagrafica_view_static` senza WHERE: sui deploy con l'anagrafica grande ( Polmasi:
	 * oltre 55.000 righe ) supera il tetto di 1 MB di memcached, la scrittura in cache fallisce
	 * con l'errore 37 e la query si rifa' a ogni apertura della pagina.
	 *
	 * Non serviva: nei template di questa pagina il campo e' reso da `frm.selectBox()` con l'api
	 * `anagrafica`, che non stampa le `<option>` e cerca via REST ( _src/_js/_lib/_selectbox.js ).
	 */
	$ct['etc']['select']['id_emittenti'] = array();

	/**
	 * tendina id_destinatari — disattivata il 2026-10-12, il campo ha gia' la ricerca REST
	 *
	 * Era `SELECT id, __label__ FROM anagrafica_view_static` senza WHERE: sui deploy con l'anagrafica grande ( Polmasi:
	 * oltre 55.000 righe ) supera il tetto di 1 MB di memcached, la scrittura in cache fallisce
	 * con l'errore 37 e la query si rifa' a ogni apertura della pagina.
	 *
	 * Non serviva: nei template di questa pagina il campo e' reso da `frm.selectBox()` con l'api
	 * `anagrafica`, che non stampa le `<option>` e cerca via REST ( _src/_js/_lib/_selectbox.js ).
	 */
	$ct['etc']['select']['id_destinatari'] = array();

    // tendina indirizzi mittenti
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) ){
	    $ct['etc']['select']['id_sedi_emittente'] = tendinaSediAnagrafica( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] );
	} else {
		$_REQUEST[ $ct['form']['table'] ]['id_destinatario'] = trovaIdAziendaGestita();
    } 

	// tendina indirizzi destinatari
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) ){
	    $ct['etc']['select']['id_sedi_destinatario'] = tendinaSediAnagrafica( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] );
	}

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
