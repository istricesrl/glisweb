<?php

    /**
     * gestione mailing
     *
     * Nome, data di invio e liste a cui il mailing va spedito.
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'mailing';

    // tendina liste
    $ct['etc']['select']['liste'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM liste_view'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
