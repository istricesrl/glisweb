<?php

    /**
     * esempio di modulaImport()
     *
     * L'output e' controllato da _mod/_I0200.modula/_usr/_test/_tests/unit/modulaUtilsCest.php: un import valido
     * passa, uno con la quantita' numerica torna la descrizione del WMS, un WMS non disponibile torna 503.
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

    var_dump( modulaImport(
        array( array( 'ORD_ORDINE' => 'LP-1', 'ORD_TIPOOP' => 'P' ) ),
        array( array( 'RIG_ORDINE' => 'LP-1', 'RIG_ARTICOLO' => 'A1', 'RIG_QTAR' => modulaQta2Testo( 2 ) ) ),
        NULL, $errore
    ) );

    var_dump( modulaImport(
        array( array( 'ORD_ORDINE' => 'LP-2', 'ORD_TIPOOP' => 'P' ) ),
        array( array( 'RIG_ORDINE' => 'LP-2', 'RIG_ARTICOLO' => 'A1', 'RIG_QTAR' => 2 ) ),
        NULL, $errore
    ) );
    var_dump( $errore );

    var_dump( modulaImport( array(), array(), 'ERR-503', $errore ) );
    var_dump( $errore );
