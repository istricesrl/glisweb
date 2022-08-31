<?php

    /**
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'gruppi';
    
    // tendina genitore 
    $ct['etc']['select']['id_genitore'] = mysqlCachedIndexedQuery(
    $cf['memcache']['index'],
    $cf['memcache']['connection'],
    $cf['mysql']['connection'],
    'SELECT id, __label__ FROM gruppi_view'
    );

    // tendina genitore 
  /*  $ct['etc']['select']['id_struttura'] = mysqlCachedIndexedQuery(
    $cf['memcache']['index'],
    $cf['memcache']['connection'],
    $cf['mysql']['connection'],
    'SELECT id, __label__ FROM anagrafica_ruoli_view'
    );*/

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
