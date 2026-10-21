<?php

    /**
     * macro della form dei listini di acquisto
     * 
     * Questa macro imposta la scheda di un listino di acquisto: è la stessa scheda dei listini di vendita
     * ( _catalogo.listini.vendita.form.php ), ma l'emittente si sceglie fra tutta l'anagrafica ed è
     * obbligatorio, perché è l'emittente che non sia un'azienda gestita a fare di un listino un listino
     * di acquisto.
     * 
     * 
     */

    // tabella gestita
    $ct['form']['table'] = 'listini';

    // tendina genitore
    $ct['etc']['select']['genitore'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM listini_view ORDER BY __label__'
    );

    // tendina tipologie listini
    $ct['etc']['select']['tipologie_listini'] = tendinaTipologieListini();

    // tendina valute
    $ct['etc']['select']['valute'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, iso4217 as __label__ FROM valute'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
