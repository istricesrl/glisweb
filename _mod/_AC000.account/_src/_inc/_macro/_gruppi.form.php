<?php

    /**
     *
     *
     *
     * TODO documentare
     *
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'gruppi';

    // tendina gruppi
    $ct['etc']['select']['gruppi'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM gruppi_view'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
