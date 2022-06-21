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

    // tendina  agente
	$ct['etc']['select']['ruoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_documenti_view WHERE se_documenti = 1'
    );

    // tendina documenti
	$ct['etc']['select']['documenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM documenti_view'
    );

    // debug
    // print_r( $ct['etc']['select']['anagrafica'] );

    // macro di default per l'entità DDT
	require DIR_BASE . '_mod/_0400.documenti/_src/_inc/_macro/_ddt.magazzini.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
