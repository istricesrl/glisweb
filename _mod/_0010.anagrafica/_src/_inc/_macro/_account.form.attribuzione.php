<?php

    /**
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'account';

    // tendina anagrafica
	$ct['etc']['select']['gruppi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM gruppi_view'
    );
    
    // impedisco che la password cifrata venga inviata al modulo
	unset( $_REQUEST['account']['password'] );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
