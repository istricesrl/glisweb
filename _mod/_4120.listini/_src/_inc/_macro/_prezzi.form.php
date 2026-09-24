<?php

/**
     * macro form articoli
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
    $ct['form']['table'] = 'prezzi';

    // tendina listini
	$ct['etc']['select']['listini'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM listini_view' );

    // tendina IVA
	$ct['etc']['select']['iva'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM iva_view' );



  

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';