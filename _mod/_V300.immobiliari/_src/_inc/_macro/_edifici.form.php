<?php

    /**
     * macro form immobili
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
	$ct['form']['table'] = 'edifici';

    // tendina indirizzi
	$ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM indirizzi_view'
	);
   
    // tendina tipologie edifici
	$ct['etc']['select']['tipologie_edifici'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_edifici_view'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
