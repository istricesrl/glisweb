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
    $ct['form']['table'] = 'categorie_risorse';

    // tendina categorie
	$ct['etc']['select']['categorie_risorse'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_risorse_view'
	);
  
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
