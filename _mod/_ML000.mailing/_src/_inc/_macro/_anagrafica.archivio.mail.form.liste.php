<?php

    /**
     * liste a cui è iscritto un indirizzo
     *
     * Scheda dell'archivio e-mail di `_AN000.anagrafica`: le liste della newsletter a cui l'indirizzo è iscritto.
     * Era la scheda `mail.form.iscrizioni` di `_7000.mailing`, sulla gestione mail del modulo anagrafica vecchio.
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'mail';

    // tendina liste
    $ct['etc']['select']['liste'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM liste_view'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
