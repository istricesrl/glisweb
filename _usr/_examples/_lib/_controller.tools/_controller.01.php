<?php

    /**
     * file di esempio per la funzione controller(): le sottoform non si scrivono se il padre è fallito
     *
     * Crea un account di test, poi ne crea un secondo con lo stesso username e una riga di account_gruppi come
     * sottoform: l'INSERT del padre dà 1062 su unica, la controller() risponde 409 e la sottoform non deve essere
     * scritta, perché resterebbe con id_account NULL. Fino al 29/10/2026 la scriveva lo stesso: 30 righe orfane
     * nella produzione di polmasi, una per ogni creazione di account fallita.
     *
     * Scrive nel database del deploy e pulisce dopo di sé; i permessi passano dalla firma di importazione.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // output
    header( 'Content-type: text/plain' );

    // senza il segreto di importazione la firma non si può calcolare
    if( empty( $cf['auth']['import']['secret'] ) ) {
        die( 'segreto di importazione assente' . PHP_EOL );
    }

    // connessioni
    $c = $cf['mysql']['connection'];
    $mc = $cf['memcache']['connection'];

    // dati di lavoro
    $u = 'TEST-E2E-controller-' . uniqid();
    $g = mysqlSelectValue( $c, 'SELECT id FROM gruppi ORDER BY id LIMIT 1' );
    $n = mysqlSelectValue( $c, 'SELECT count( * ) FROM account_gruppi WHERE id_account IS NULL' );
    $m = (int) mysqlSelectValue( $c, 'SELECT coalesce( max( id ), 0 ) FROM account_gruppi' );

    // primo account
    $d = array(
        'username' => $u,
        '__firma__' => hash( getAvailableHashMethod(), 'account' . $cf['auth']['import']['secret'] )
    );
    echo 'primo account: ' . controller( $c, $mc, $d, 'account', METHOD_POST ) . PHP_EOL;

    // secondo account con lo stesso username e una sottoform
    $d = array(
        'username' => $u,
        '__firma__' => hash( getAvailableHashMethod(), 'account' . $cf['auth']['import']['secret'] ),
        'account_gruppi' => array(
            array(
                'id_account' => '__parent_id__',
                'id_gruppo' => $g,
                '__firma__' => hash( getAvailableHashMethod(), 'account_gruppi' . $cf['auth']['import']['secret'] )
            )
        )
    );
    echo 'secondo account: ' . controller( $c, $mc, $d, 'account', METHOD_POST ) . PHP_EOL;

    // righe di account_gruppi rimaste senza account
    echo 'sottoform orfane: ' . ( mysqlSelectValue( $c, 'SELECT count( * ) FROM account_gruppi WHERE id_account IS NULL' ) - $n ) . PHP_EOL;

    // pulizia: le orfane scritte da questo esempio sono quelle con un id più alto di tutte quelle che c'erano
    mysqlQuery( $c, 'DELETE FROM account_gruppi WHERE id_account IS NULL AND id > ?', array( array( 's' => $m ) ) );
    mysqlQuery( $c, 'DELETE FROM account_gruppi WHERE id_account IN ( SELECT id FROM account WHERE username = ? )', array( array( 's' => $u ) ) );
    mysqlQuery( $c, 'DELETE FROM account WHERE username = ?', array( array( 's' => $u ) ) );
