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
	$ct['form']['table'] = 'periodi';

    // tendina tipologie indirizzi
	$ct['etc']['select']['tipologie_periodi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_periodi_view'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
