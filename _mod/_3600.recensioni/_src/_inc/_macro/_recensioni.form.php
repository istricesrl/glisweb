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
	$ct['form']['table'] = 'recensioni';

    // tendina lingue
    $ct['etc']['select']['id_lingua'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT * FROM lingue_view'
    );

    // tendina prodotti
    $ct['etc']['select']['id_prodotto'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT * FROM prodotti_view'
    );

    // tendina pagine
    $ct['etc']['select']['id_pagina'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT * FROM pagine_view'
    );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.form.php';
