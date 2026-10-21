<?php

    /**
     * gestione iscrizione
     *
     * Una riga di `liste_mail`: la lista e l'indirizzo iscritto.
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'liste_mail';

    // tendina liste
    $ct['etc']['select']['liste'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM liste_view'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
