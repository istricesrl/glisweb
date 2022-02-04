<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'categorie_progetti';

    // tendina categorie
	$ct['etc']['select']['categorie_progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view'
	);
  
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
