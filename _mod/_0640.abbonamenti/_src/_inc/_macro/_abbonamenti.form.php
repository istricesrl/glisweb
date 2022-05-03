<?php

    /**
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
	$ct['form']['table'] = 'contratti';

    $ct['form']['subtable'] = 'contratti_anagrafica';

    // tendina tesserato
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
