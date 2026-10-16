<?php

    /**
     * esempio di modulaQta2Testo()
     *
     * L'output e' controllato da _mod/_I0200.modula/_usr/_test/_tests/unit/modulaUtilsCest.php: le quantita'
     * vanno al WMS come testo con la virgola e tre decimali.
     *
     */

    require '../../../../../../_src/_config.php';

    // il server finto del WMS, acceso per dieci minuti
    touch( DIR_VAR . 'test/modula.fake.on' );
    $cf['modula']['profile']['url'] = $cf['site']['url'] . '_mod/_I0200.modula/_usr/_test/_fake/_wms.php';
    $cf['modula']['profile']['username'] = 'modula';
    $cf['modula']['profile']['password'] = 'fake';
    $cf['modula']['profile']['auth'] = 'bearer';

    var_dump( modulaQta2Testo( 1 ) );
    var_dump( modulaQta2Testo( 12.5 ) );
    var_dump( modulaQta2Testo( '1500' ) );
