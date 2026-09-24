<?php

    /**
     * macro form anagrafica
     *
     *
     * TODO documentare
     *
     */

    /**
     * configurazione del form
     * =======================
     * 
     * 
     * 
     */

    // tabella gestita
    $ct['form'] = array(
        'table' => 'ruoli_anagrafica',
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

    // tendina ruoli anagrafica
    $ct['etc']['select']['ruoli_anagrafica'] =  mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM ruoli_anagrafica_view ORDER BY __label__'
    );

    /**
     * macro di default
     * ================
     * 
     * 
     * 
     * 
     */

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    /**
     * debug del form
     * ==============
     * 
     * 
     * 
     */

    // debug
    // print_r( $_REQUEST );
