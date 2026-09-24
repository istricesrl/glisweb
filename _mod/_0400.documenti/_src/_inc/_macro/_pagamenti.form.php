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
	$ct['form']['table'] = 'pagamenti';

	// tendina tipologie anagrafica
	$ct['etc']['select']['modalita_pagamento'] = mysqlCachedIndexedQuery(
		$cf['memcache']['index'],
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id, __label__ FROM modalita_pagamento_view'
	);

	if( isset( $_REQUEST['pagamenti']['id_documento'] ) ){

		// tendina iban
		$ct['etc']['select']['iban'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT iban_view.id, iban_view.__label__ FROM iban_view '.
			'LEFT JOIN documenti ON documenti.id_emittente = iban_view.id_anagrafica '.
			'WHERE documenti.id = ? ',
			array( array( 's' => $_REQUEST['pagamenti']['id_documento'] ) )
		);

	} elseif( isset( $_REQUEST['__preset__']['pagamenti']['id_documento'] ) ){

		// tendina iban
		$ct['etc']['select']['iban'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT iban_view.id, iban_view.__label__ FROM iban_view '.
			'LEFT JOIN documenti ON documenti.id_emittente = iban_view.id_anagrafica '.
			'WHERE documenti.id = ? ',
			array( array( 's' => $_REQUEST['__preset__']['pagamenti']['id_documento'] ) )
		);

	} else {
		// tendina iban
		$ct['etc']['select']['iban'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM iban_view'
		);
	}


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
		'SELECT id, __label__ FROM mastri_view WHERE id_tipologia = 2'
	);

	// tendina progetti
	$ct['etc']['select']['id_progetti'] = mysqlCachedIndexedQuery(
		$cf['memcache']['index'],
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id, __label__ FROM progetti_view '
	);

	$ct['etc']['select']['id_documenti'] = mysqlCachedIndexedQuery(
		$cf['memcache']['index'],
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id, __label__ FROM documenti_view '
	);

    /**
     * tendina anagrafica — svuotata il 2026-09-10, i due campi ora cercano via REST
     *
     * Era `SELECT id, __label__ FROM anagrafica_view_static` senza WHERE. Su un deploy con
     * l'anagrafica grande ( Polmasi: 55.372 righe ) sono 4,58 MB serializzati, che compressi fanno
     * 1,00 MB: sopra il tetto di memcached, quindi la scrittura in cache fallisce con l'errore 37
     * e la query si rifa' a ogni apertura del form.
     *
     * A differenza degli altri casi tolti lo stesso giorno, qui la lista **veniva davvero
     * stampata**: i campi `id_creditore` e `id_debitore` di
     * `_src/_templates/_athena/pagamenti.form.html` chiamavano `frm.selectBox()` senza l'ultimo
     * argomento `api`, quindi rendevano una `<select>` vera con 55.372 `<option>` dentro.
     * Svuotare la lista senza toccare il template avrebbe lasciato due tendine vuote.
     *
     * Percio' e' stata aggiunta l'api a quelle due chiamate ( `..., ietf, 'anagrafica' )` ), come
     * ce l'hanno gia' tutti gli altri campi anagrafica del framework: la macro rende un hidden e
     * lascia cercare a `_src/_js/_lib/_selectbox.js` da tre caratteri in su, e l'etichetta del
     * valore gia' scelto arriva da `/api/anagrafica/<id>`. Il valore di default ( `default_mp` )
     * continua a passare come prima.
     */
    $ct['etc']['select']['anagrafica'] = array();

		// macro di default
		require DIR_SRC_INC_MACRO . '_default.form.php';
