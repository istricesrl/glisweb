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
	$ct['form']['table'] = 'progetti';

    // tendina clienti
	$ct['etc']['select']['clienti'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view WHERE se_cliente = 1'
    );
    
    // tendina tipologie
	$ct['etc']['select']['tipologie_progetti'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_progetti_view'
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
