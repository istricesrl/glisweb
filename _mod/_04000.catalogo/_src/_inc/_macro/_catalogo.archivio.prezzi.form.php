<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // tabella gestita
    $ct['form']['table'] = 'prezzi';

    // dati delle tendine

    // tendina reparti
    $ct['etc']['select']['reparti'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM reparti_view ORDER BY __label__'
    );

    // tendina listini
    $ct['etc']['select']['listini'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM listini_view ORDER BY __label__'
    );

    // tendina prodotti
    $ct['etc']['select']['prodotti'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM prodotti_view ORDER BY __label__'
    );

    // tendina articoli
    $ct['etc']['select']['articoli'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM articoli_view ORDER BY __label__'
    );

    // tendina iva
    $ct['etc']['select']['iva'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM iva_view ORDER BY __label__'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

