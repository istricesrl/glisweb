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
    $ct['form']['table'] = 'articoli';

    // tendina ruoli
    $ct['etc']['select']['ruoli'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM ruoli_articoli_view ORDER BY __label__'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

