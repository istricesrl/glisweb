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
   $ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	$cf['memcache']['index'],
	$cf['memcache']['connection'],
	$cf['mysql']['connection'],
	'SELECT id, __label__ FROM tipologie_pagamenti_view'
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
	'SELECT id, __label__ FROM todo_completa_view '
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
	'SELECT id, __label__ FROM anagrafica_view_static '
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

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
