<?php

    /**
     *
     *
     *
     * @todo documentare
     * 
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'risorse';

    // tendina tipologie
    $ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_risorse_view' 
    );

    // tendina categorie
    $ct['etc']['select']['categorie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM categorie_risorse_view' 
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
