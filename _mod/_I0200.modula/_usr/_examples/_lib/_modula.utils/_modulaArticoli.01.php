<?php

    /**
     * esempio di modulaArticoli()
     *
     * L'output e' controllato da _mod/_I0200.modula/_usr/_test/_tests/unit/modulaUtilsCest.php: l'anagrafica passa,
     * un ordine su un articolo in anagrafica passa, uno su un articolo che il WMS non conosce torna il 400 in JSON
     * del WMS e l'intero pacchetto viene rifiutato.
     *
     */

    require '../../../../../../_src/_config.php';

    // il server finto del WMS, acceso per dieci minuti
    touch( DIR_VAR . 'test/modula.fake.on' );
    $cf['modula']['profile']['url'] = $cf['site']['url'] . '_mod/_I0200.modula/_usr/_test/_fake/_wms.php';
    $cf['modula']['profile']['username'] = 'modula';
    $cf['modula']['profile']['password'] = 'fake';
    $cf['modula']['profile']['auth'] = 'bearer';

    modulaChiamata( '/reset', METHOD_POST );

    var_dump( 'anagrafica ' . ( modulaArticoli( array(
        array( 'ART_OPERAZIONE' => 'I', 'ART_ARTICOLO' => 'A1', 'ART_DES' => 'articolo uno', 'ART_UMI' => 'FF' )
    ) ) ? 'accettata' : 'rifiutata' ) );

    var_dump( 'ordine noto ' . ( modulaImport(
        array( array( 'ORD_OPERAZIONE' => 'I', 'ORD_ORDINE' => 'LP-1', 'ORD_TIPOOP' => 'P' ) ),
        array( array( 'RIG_ORDINE' => 'LP-1', 'RIG_ARTICOLO' => 'A1', 'RIG_QTAR' => modulaQta2Testo( 2 ), 'RIG_HOSTINF' => '1' ) )
    ) ? 'accettato' : 'rifiutato' ) );

    var_dump( 'ordine ignoto ' . ( modulaImport(
        array( array( 'ORD_OPERAZIONE' => 'I', 'ORD_ORDINE' => 'LP-2', 'ORD_TIPOOP' => 'P' ) ),
        array(
            array( 'RIG_ORDINE' => 'LP-2', 'RIG_ARTICOLO' => 'A1', 'RIG_QTAR' => modulaQta2Testo( 1 ), 'RIG_HOSTINF' => '2' ),
            array( 'RIG_ORDINE' => 'LP-2', 'RIG_ARTICOLO' => 'A9', 'RIG_QTAR' => modulaQta2Testo( 1 ), 'RIG_HOSTINF' => '3' )
        ),
        NULL, $errore
    ) ? 'accettato' : 'rifiutato' ) );
    var_dump( $errore );

    $stato = modulaExport();
    var_dump( 'ordini nel WMS ' . count( $stato['DATA']['EXP_ORDINI'] ) );
    modulaAck( $stato['GUID'] );
