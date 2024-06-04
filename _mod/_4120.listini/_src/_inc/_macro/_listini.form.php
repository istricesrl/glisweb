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
    $ct['form']['table'] = 'listini';

    // tendina listini
	$ct['etc']['select']['listini'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM listini_view' );

    // tendina IVA
	$ct['etc']['select']['valute'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM valute_view' );

    // tendina notifiche
	$ct['etc']['select']['se_default'] = array(
	    array( 'id' => NULL, '__label__' => 'se un prezzo è assente in questo listino, NON prelevarlo dal listino genitore' ),
	    array( 'id' => 1, '__label__' => 'se un prezzo è assente in questo listino, PRELEVALO dal listino genitore' )
	);



  

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';