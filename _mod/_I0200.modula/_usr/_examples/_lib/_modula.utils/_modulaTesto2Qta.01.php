<?php

    /**
     * esempio di modulaTesto2Qta()
     *
     * L'output e' controllato da _mod/_I0200.modula/_usr/_test/_tests/unit/modulaUtilsCest.php: il testo del WMS
     * torna un numero.
     *
     */

    require '../../../../../../_src/_config.php';

    // il server finto del WMS, acceso per dieci minuti
    touch( DIR_VAR . 'test/modula.fake.on' );
    $cf['modula']['profile']['url'] = $cf['site']['url'] . '_mod/_I0200.modula/_usr/_test/_fake/_wms.php';
    $cf['modula']['profile']['username'] = 'modula';
    $cf['modula']['profile']['password'] = 'fake';
    $cf['modula']['profile']['auth'] = 'bearer';

    var_dump( '1,000 ' . ( ( modulaTesto2Qta( '1,000' ) === (float) 1 ) ? 'ok' : 'ko' ) );
    var_dump( '12,500 ' . ( ( modulaTesto2Qta( '12,500' ) === (float) 12.5 ) ? 'ok' : 'ko' ) );
    var_dump( '0,000 ' . ( ( modulaTesto2Qta( '0,000' ) === (float) 0 ) ? 'ok' : 'ko' ) );
