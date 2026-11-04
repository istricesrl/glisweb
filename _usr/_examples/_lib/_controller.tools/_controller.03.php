<?php

    /**
     * file di esempio per isFieldPresent(), getNextOrder() e l'ordinamento delle sottoform per ordine
     *
     * Crea un account di test con tre righe di account_gruppi scritte fuori ordine ( ordine 30, 15, 20 ), poi:
     * - verifica isFieldPresent() su un campo che c'è e su uno che non c'è;
     * - chiede a getNextOrder() l'ordine della prossima riga: il multiplo di dieci dopo il più alto, cioè 40;
     * - verifica che getNextOrder() rifiuti un campo che non è una chiave esterna e una tabella senza ordine;
     * - rilegge l'account con la controller() e stampa l'ordine delle sottoform, che senza l'indice SORTING
     *   seguono il campo ordine ( 15, 20, 30 ) e non l'ordine di inserimento.
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

    // servono tre gruppi diversi
    $g = mysqlSelectColumn( 'id', $c, 'SELECT id FROM gruppi ORDER BY id LIMIT 3' );
    if( count( $g ) < 3 ) {
        die( 'servono almeno tre gruppi' . PHP_EOL );
    }

    // campi presenti e assenti
    echo 'ordine in account_gruppi: ' . var_export( isFieldPresent( $mc, $c, 'account_gruppi', 'ordine' ), true ) . PHP_EOL;
    echo 'campo inesistente: ' . var_export( isFieldPresent( $mc, $c, 'account_gruppi', 'campo_inesistente' ), true ) . PHP_EOL;

    // account con tre sottoform fuori ordine
    $f = hash( getAvailableHashMethod(), 'account_gruppi' . $cf['auth']['import']['secret'] );
    $d = array(
        'username' => 'TEST-E2E-ordine-' . uniqid(),
        '__firma__' => hash( getAvailableHashMethod(), 'account' . $cf['auth']['import']['secret'] ),
        'account_gruppi' => array(
            array( 'id_account' => '__parent_id__', 'id_gruppo' => $g[0], 'ordine' => 30, '__firma__' => $f ),
            array( 'id_account' => '__parent_id__', 'id_gruppo' => $g[1], 'ordine' => 15, '__firma__' => $f ),
            array( 'id_account' => '__parent_id__', 'id_gruppo' => $g[2], 'ordine' => 20, '__firma__' => $f )
        )
    );
    echo 'inserimento: ' . controller( $c, $mc, $d, 'account', METHOD_POST ) . PHP_EOL;
    $id = $d['id'];

    // ordine della prossima riga
    echo 'prossimo ordine: ' . var_export( getNextOrder( $mc, $c, 'account_gruppi', 'id_account', $id ), true ) . PHP_EOL;
    echo 'campo non valido: ' . var_export( getNextOrder( $mc, $c, 'account_gruppi', 'id_account = 0 OR 1', $id ), true ) . PHP_EOL;
    echo 'tabella senza ordine: ' . var_export( getNextOrder( $mc, $c, 'gruppi', 'id_genitore', $id ), true ) . PHP_EOL;

    // rilettura con le sottoform
    $r = array( 'id' => $id, '__firma__' => $d['__firma__'] );
    controller( $c, $mc, $r, 'account', METHOD_GET );
    $o = array();
    foreach( $r['account_gruppi'] ?? array() as $s ) {
        $o[] = mysqlSelectValue( $c, 'SELECT ordine FROM account_gruppi WHERE id = ?', array( array( 's' => $s['id'] ) ) );
    }
    echo 'ordine delle sottoform: ' . implode( ', ', $o ) . PHP_EOL;

    // pulizia
    mysqlQuery( $c, 'DELETE FROM account_gruppi WHERE id_account = ?', array( array( 's' => $id ) ) );
    mysqlQuery( $c, 'DELETE FROM account WHERE id = ?', array( array( 's' => $id ) ) );
