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
			'LEFT JOIN documenti ON documenti.id_destinatario = iban_view.id_anagrafica '.
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
			'LEFT JOIN documenti ON documenti.id_destinatario = iban_view.id_anagrafica '.
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

	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
		$cf['memcache']['index'],
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id, __label__ FROM anagrafica_view_static '
	);

		// macro di default
		require DIR_SRC_INC_MACRO . '_default.form.php';
