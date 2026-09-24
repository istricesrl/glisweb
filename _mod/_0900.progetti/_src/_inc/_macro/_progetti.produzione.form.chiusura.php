<?php

    /**
     * macro form progetti chiusura
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
	$ct['form']['table'] = 'progetti';

    // tendina mastri attivita
	$ct['etc']['select']['periodicita'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM periodicita_view ORDER BY giorni ASC'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
