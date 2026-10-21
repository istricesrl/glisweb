<?php

    /**
     * esempio di modulaToken()
     *
     * L'output e' controllato da _mod/_I0200.modula/_usr/_test/_tests/unit/modulaUtilsCest.php: con le credenziali
     * giuste il token c'e', con quelle sbagliate no.
     *
     */

    require '../../../../../../_src/_config.php';

    // il server finto del WMS, acceso per dieci minuti
    touch( DIR_VAR . 'test/modula.fake.on' );
    $cf['modula']['profile']['url'] = $cf['site']['url'] . '_mod/_I0200.modula/_usr/_test/_fake/_wms.php';
    $cf['modula']['profile']['username'] = 'modula';
    $cf['modula']['profile']['password'] = 'fake';
    $cf['modula']['profile']['auth'] = 'bearer';

    $token = modulaToken( true );
    var_dump( 'token ' . ( ( strlen( $token ) == 64 ) ? 'ok' : 'ko' ) );

    $cf['modula']['profile']['password'] = 'sbagliata';
    var_dump( modulaToken( true ) );
