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
    $ct['form']['table'] = 'modalita_spedizione';
    
    // tendina IVA
	$ct['etc']['select']['iva'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM iva_view' );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
