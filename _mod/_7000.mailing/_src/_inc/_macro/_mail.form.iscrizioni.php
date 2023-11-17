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
	$ct['form']['table'] = 'mail';

    // tendina liste
	$ct['etc']['select']['liste'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM liste_view'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
