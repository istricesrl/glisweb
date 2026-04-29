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
    $ct['form']['table'] = 'listini';


    /**
     * dati delle tendine
     * ==================
     * 
     * 
     * 
     * 
     * 
     */
    // tendina genitore
    $ct['etc']['select']['genitore'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM listini_view ORDER BY __label__'
    );

   // tendina tipologie listini
    $ct['etc']['select']['tipologie_listini'] = tendinaTipologieListini();


    // tendina valute
    $ct['etc']['select']['valute'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, iso4217 as __label__ FROM valute'
    );

 //   print_r($ct['etc']['select']['valute']);

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
