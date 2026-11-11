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

    // tabella gestita: i veicoli sono asset ( la vista virtuale veicoli_view li elenca )
    $ct['form']['table'] = 'asset';

    // tendina tipologie veicoli
    $ct['etc']['select']['tipologie_veicoli'] = tendinaTipologieVeicoli();

    // tendina produttori
    $ct['etc']['select']['produttori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_produttore = 1'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
