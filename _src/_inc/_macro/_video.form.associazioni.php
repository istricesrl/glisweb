<?php

    /**
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'video';

    // tendina pagine
	$ct['etc']['select']['pagine'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM pagine_view' 
    );

    // tendina eventi
	$ct['etc']['select']['eventi'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM eventi_view' 
    );

    // tendina prodotti
	$ct['etc']['select']['prodotti'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM prodotti_view' 
    );

    // tendina categorie prodotti
	$ct['etc']['select']['categorie_prodotti'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM categorie_prodotti_view' 
    );

    // tendina ruoli
	$ct['etc']['select']['ruoli'] = mysqlQuery( 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM ruoli_video_view' 
    );

    // tendina anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static' 
    );

    
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
