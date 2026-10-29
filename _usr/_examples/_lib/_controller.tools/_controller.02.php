<?php

    /**
     * file di esempio per la funzione controller(): il controller di immagini toglie dalla coda i file non scalabili
     *
     * Scrive un'immagine di test con un percorso SVG, che il task di scalamento non sa lavorare: il controller before di
     * immagini ( _src/_inc/_controllers/_immagini.before.php ) le mette il token di stato NON_SCALABILE. Poi le cambia il
     * percorso in un JPEG, e il token deve sparire, così il task la riprende. Fino al 30/10/2026 le righe non scalabili
     * restavano in coda e il task ci girava sopra a ogni giro.
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
    $n = 'TEST-E2E-immagini-' . uniqid();
    $f = hash( getAvailableHashMethod(), 'immagini' . $cf['auth']['import']['secret'] );

    // immagine con un percorso SVG
    $d = array( 'nome' => $n, 'path' => 'var/immagini/' . $n . '.svg', '__firma__' => $f );
    echo 'inserimento: ' . controller( $c, $mc, $d, 'immagini', METHOD_POST ) . PHP_EOL;
    $id = mysqlSelectValue( $c, 'SELECT id FROM immagini WHERE nome = ?', array( array( 's' => $n ) ) );
    echo 'token col percorso SVG: ' . var_export( mysqlSelectValue( $c, 'SELECT token FROM immagini WHERE id = ?', array( array( 's' => $id ) ) ), true ) . PHP_EOL;

    // stessa immagine con un percorso JPEG
    $d = array( 'id' => $id, 'path' => 'var/immagini/' . $n . '.jpg', '__firma__' => $f );
    echo 'aggiornamento: ' . controller( $c, $mc, $d, 'immagini', METHOD_UPDATE ) . PHP_EOL;
    echo 'token col percorso JPEG: ' . var_export( mysqlSelectValue( $c, 'SELECT token FROM immagini WHERE id = ?', array( array( 's' => $id ) ) ), true ) . PHP_EOL;

    // pulizia
    mysqlQuery( $c, 'DELETE FROM immagini WHERE nome = ?', array( array( 's' => $n ) ) );
