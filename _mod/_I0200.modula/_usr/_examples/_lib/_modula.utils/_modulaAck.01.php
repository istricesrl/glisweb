<?php

    /**
     * esempio di modulaAck()
     *
     * L'output e' controllato da _mod/_I0200.modula/_usr/_test/_tests/unit/modulaUtilsCest.php: un GUID che il WMS
     * non ha emesso viene rifiutato.
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

    var_dump( 'ack ' . ( ( modulaAck( '00000000-0000-0000-0000-000000000000' ) ) ? 'accettato' : 'rifiutato' ) );
