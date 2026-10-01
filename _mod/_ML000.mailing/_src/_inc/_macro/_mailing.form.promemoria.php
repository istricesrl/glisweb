<?php

    /**
     * follow-up del mailing
     *
     * Se il mailing ha una tipologia di follow-up, `_genera.mail.php` crea un'attività per ogni destinatario che ha
     * un'anagrafica, programmata dopo i giorni indicati. La scheda c'è solo se è attivo `_AT000.attivita`.
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'mailing';

    // tendina tipologie attività
    $ct['etc']['select']['id_tipologia'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL ORDER BY __label__'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
