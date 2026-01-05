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
	$ct['form']['table'] = 'anagrafica_indirizzi';

    // tendina  agente
	$ct['etc']['select']['ruoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_indirizzi_view'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
