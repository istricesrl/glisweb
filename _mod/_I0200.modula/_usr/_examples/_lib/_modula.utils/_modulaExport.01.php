<?php

    /**
     * esempio di modulaExport()
     *
     * L'output e' controllato da _mod/_I0200.modula/_usr/_test/_tests/unit/modulaUtilsCest.php: tre ordini
     * tornano in due pacchetti, CHUNK e END; finche' non c'e' l'ack il pacchetto si ripete; la riga dell'articolo MANCA
     * torna a zero; alla fine non c'e' niente ( 204 ). Qui l'autenticazione e' Basic.
     *
     */

    require '../../../../../../_src/_config.php';

    // il server finto del WMS, acceso per dieci minuti
    touch( DIR_VAR . 'test/modula.fake.on' );
    $cf['modula']['profile']['url'] = $cf['site']['url'] . '_mod/_I0200.modula/_usr/_test/_fake/_wms.php';
    $cf['modula']['profile']['username'] = 'modula';
    $cf['modula']['profile']['password'] = 'fake';
    $cf['modula']['profile']['auth'] = 'basic';

    modulaChiamata( '/reset', METHOD_POST );

    modulaImport(
        array(
            array( 'ORD_ORDINE' => 'LP-1', 'ORD_TIPOOP' => 'P' ),
            array( 'ORD_ORDINE' => 'LP-2', 'ORD_TIPOOP' => 'P' ),
            array( 'ORD_ORDINE' => 'LP-3', 'ORD_TIPOOP' => 'P' )
        ),
        array(
            array( 'RIG_ORDINE' => 'LP-1', 'RIG_ARTICOLO' => 'A1', 'RIG_QTAR' => '2,000' ),
            array( 'RIG_ORDINE' => 'LP-1', 'RIG_ARTICOLO' => 'MANCA', 'RIG_QTAR' => '1,000' ),
            array( 'RIG_ORDINE' => 'LP-3', 'RIG_ARTICOLO' => 'A3', 'RIG_QTAR' => '1,000' )
        )
    );

    $primo = modulaExport();
    $ripetuto = modulaExport();
    var_dump( 'primo ' . $primo['TransactionStatus'] . ' ordini ' . count( $primo['DATA']['EXP_ORDINI'] ) );
    var_dump( 'ripetuto ' . ( ( $primo['GUID'] == $ripetuto['GUID'] ) ? 'si' : 'no' ) );
    foreach( $primo['DATA']['EXP_ORDINI_RIGHE'] as $riga ) {
        var_dump( $riga['RIG_ARTICOLO'] . ' evasa ' . modulaTesto2Qta( $riga['RIG_QTAE'] ) );
    }
    var_dump( modulaAck( $primo['GUID'] ) );

    $secondo = modulaExport();
    var_dump( 'secondo ' . $secondo['TransactionStatus'] . ' ordini ' . count( $secondo['DATA']['EXP_ORDINI'] ) );
    var_dump( modulaAck( $secondo['GUID'] ) );

    var_dump( modulaExport( NULL, $status ) );
    var_dump( 'status ' . $status );
