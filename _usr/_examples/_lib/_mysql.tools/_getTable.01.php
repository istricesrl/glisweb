<?php

    /**
     * file di esempio per la funzione getTable()
     *
     * Mostra l'esito su una tabella esistente, su un nome vuoto, su una tabella che non esiste e su un nome con dentro
     * del codice SQL: solo il primo restituisce il nome, gli altri false. Senza memcache, per non leggere esiti vecchi.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // connessione
    $c = $cf['mysql']['connection'];

    // tabella esistente
    echo 'esistente: ' . var_export( getTable( NULL, $c, 'anagrafica' ), true ) . PHP_EOL;

    // nome vuoto
    echo 'vuota: ' . var_export( getTable( NULL, $c, '' ), true ) . PHP_EOL;

    // nome assente
    echo 'assente: ' . var_export( getTable( NULL, $c, NULL ), true ) . PHP_EOL;

    // tabella inesistente
    echo 'inesistente: ' . var_export( getTable( NULL, $c, 'test_e2e_tabella_inesistente' ), true ) . PHP_EOL;

    // nome con codice SQL
    echo 'maligna: ' . var_export( getTable( NULL, $c, 'anagrafica_view WHERE 1=1 UNION SELECT password FROM account -- ' ), true ) . PHP_EOL;

    // nome non stringa
    echo 'array: ' . var_export( getTable( NULL, $c, array( 'anagrafica' ) ), true ) . PHP_EOL;
