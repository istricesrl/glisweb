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
    $ct['form']['table'] = 'marchi';

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

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
