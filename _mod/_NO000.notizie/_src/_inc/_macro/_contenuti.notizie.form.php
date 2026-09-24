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
    $ct['form']['table'] = 'notizie';

    // tendina tipologie notizie
    $ct['etc']['select']['tipologie_notizie'] = tendinaTipologieNotizie();

    // tendina categorie notizie
    $ct['etc']['select']['categorie_notizie'] = tendinaCategorieNotizie();

    // tendina ruoli_anagrafica
    $ct['etc']['select']['ruoli_anagrafica'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM ruoli_anagrafica_view WHERE se_notizie = 1'
    );


    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
