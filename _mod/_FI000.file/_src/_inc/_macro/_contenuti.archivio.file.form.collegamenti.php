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
    $ct['form']['table'] = 'file';

    //tendina pagine
    $ct['etc']['select']['pagine'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM pagine_view ORDER BY __label__'
    );

    //tendina template
    $ct['etc']['select']['templates'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM template_view ORDER BY __label__'
    );

    //tendina mail_out
    $ct['etc']['select']['mail_out'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM mail_out_view ORDER BY __label__'
    );   

    //tendina mail_sent
    $ct['etc']['select']['mail_sent'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM mail_sent_view ORDER BY __label__'
    );   

    //tendina notizie
    $ct['etc']['select']['notizie'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM notizie_view ORDER BY __label__'
    );

    //tendina categorie notizie
    $ct['etc']['select']['categorie_notizie'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM categorie_notizie_view ORDER BY __label__'
    );

    //tendina prodotti
    $ct['etc']['select']['prodotti'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM prodotti_view ORDER BY __label__'
    );

    //tendina categorie prodotti
    $ct['etc']['select']['categorie_prodotti'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM categorie_prodotti_view ORDER BY __label__'
    );

    //tendina marchi
    $ct['etc']['select']['marchi'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM marchi_view ORDER BY __label__'
    );

    //tendina articoli
    $ct['etc']['select']['articoli'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM articoli_view ORDER BY __label__'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

