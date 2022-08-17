<?php

    /**
     *
     *
     *
     *
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
	$ct['form']['table'] = 'crediti';

    // tendina scarico
	$ct['etc']['select']['scarico'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mastri_view WHERE id_tipologia=4'
	);

    // tendina carico
	$ct['etc']['select']['carico'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mastri_view WHERE id_tipologia=4'
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
