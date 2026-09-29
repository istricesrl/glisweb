<?php

    /**
     * macro della scheda dati fiscali del documento
     *
     * Questa macro prepara la scheda con i dati della fattura elettronica che non stanno nella scheda principale: il bollo
     * virtuale ( DatiBollo ), le ritenute ( DatiRitenuta, tabella documenti_ritenute ) e i contributi alle casse
     * previdenziali ( DatiCassaPrevidenziale, tabella documenti_casse_previdenziali ). Ritenute e contributi sono sotto
     * moduli del documento, come le relazioni; importi e imponibili lasciati vuoti li calcola generaContenutiDocumento()
     * quando la stampa _fattura.xml.php genera la fattura elettronica. La scheda è la stessa per fatture e note di credito,
     * come quella dei pagamenti.
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'documenti';

    // tendina ritenute ( TipoRitenuta )
	$ct['etc']['select']['ritenute'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ritenute_view ORDER BY codice ASC'
	);

    // tendina casse previdenziali ( TipoCassa )
	$ct['etc']['select']['casse_previdenziali'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM casse_previdenziali_view ORDER BY codice ASC'
	);

    // tendina iva dei contributi
    // NOTA senza le aliquote archiviate, tranne quelle che i contributi del documento usano già, perché salvando non vadano perse
	$ct['etc']['select']['iva'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT id, concat( __label__, if( timestamp_archiviazione IS NULL, "", " ( archiviata )" ) ) AS __label__ FROM iva_view '.
	    'WHERE timestamp_archiviazione IS NULL OR id IN ( SELECT id_iva FROM documenti_casse_previdenziali WHERE id_documento = ? ) '.
	    'ORDER BY aliquota DESC, __label__ ASC',
	    array( array( 's' => ( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) ? $_REQUEST[ $ct['form']['table'] ]['id'] : NULL ) )
	);

    // tendina causali del pagamento, i codici della Certificazione Unica ammessi dallo schema della fattura elettronica
    // NOTA manca Z, che le specifiche ammettono solo per le fatture emesse fino al 31/12/2020
	foreach( array( 'A', 'B', 'C', 'D', 'E', 'G', 'H', 'I', 'L', 'L1', 'M', 'M1', 'M2', 'N', 'O', 'O1', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'V1', 'W', 'X', 'Y', 'ZO' ) as $causale ) {
	    $ct['etc']['select']['causali_pagamento'][] = array( 'id' => $causale, '__label__' => $causale );
	}

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
