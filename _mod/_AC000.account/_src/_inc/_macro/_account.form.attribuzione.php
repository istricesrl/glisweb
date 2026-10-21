<?php

    /**
     * macro della scheda attribuzione del form di gestione degli account
     * 
     * Questa macro gestisce la scheda attribuzione del form di gestione degli account.
     *
     *
     *
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'account';

    // tendina gruppi
    $ct['etc']['select']['gruppi'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM gruppi_view'
    );

    // tendina entità ( solo le tabelle che hanno la loro __acl_<tabella>__ )
    $ct['etc']['select']['entita'] = array(
        array( 'id' => 'anagrafica', '__label__' => 'anagrafica' ),
        array( 'id' => 'attivita', '__label__' => 'attività' ),
        array( 'id' => 'pagine', '__label__' => 'pagine' )
    );

    // tendina permessi
    $ct['etc']['select']['permesso'] = array(
        array( 'id' => 'FULL', '__label__' => 'accesso completo' ),
        array( 'id' => 'FILTERED', '__label__' => 'accesso filtrato' ),
        array( 'id' => 'GET', '__label__' => 'sola lettura' )
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
