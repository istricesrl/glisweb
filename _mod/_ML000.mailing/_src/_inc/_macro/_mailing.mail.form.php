<?php

    /**
     * gestione destinatario del mailing
     *
     * Una riga di `mailing_mail`: il mailing, l'indirizzo e la data di invio.
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'mailing_mail';

    // tendina mailing
    $ct['etc']['select']['mailing'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM mailing_view'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
