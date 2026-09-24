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
    $ct['form']['table'] = 'prodotti';

    // tipologie di documenti
    $ct['etc']['select']['tipologie_prodotti'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_prodotti_view ORDER BY __label__ ASC'
    );

    // tipologie di documenti
    $ct['etc']['select']['categorie_prodotti'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM categorie_prodotti_view ORDER BY __label__ ASC'
    );

    /**
     * dati delle tendine
     * ==================
     * 
     * 
     * 
     * 
     * 
     */

    // tendina produttori
    $ct['etc']['select']['produttori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_produttore = 1'
    );

    // tendina marchi
    $ct['etc']['select']['marchi'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM marchi_view'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
