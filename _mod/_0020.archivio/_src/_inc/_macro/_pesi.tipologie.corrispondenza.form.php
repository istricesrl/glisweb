<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'pesi_tipologie_corrispondenza';

	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
		$cf['memcache']['index'],
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id, __label__ FROM tipologie_corrispondenza_view'
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
