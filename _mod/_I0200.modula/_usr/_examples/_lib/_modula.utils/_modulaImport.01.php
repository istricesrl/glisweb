<?php

    /**
     * esempio di modulaImport()
     *
     * L'output e' controllato da _mod/_I0200.modula/_usr/_test/_tests/unit/modulaUtilsCest.php: un import valido
     * passa, uno con la quantita' numerica torna la descrizione del WMS, un WMS non disponibile torna lo
     * status 0 con l'errore di curl. Il WMS non disponibile si simula puntando il profilo su una porta chiusa, non
     * col server finto: un 5xx vero finirebbe nell'access.log del deploy.
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

    // WMS non disponibile: nessuno ascolta sulla porta 1
    $cf['modula']['profile']['url'] = 'http://127.0.0.1:1/';
    $cf['modula']['profile']['auth'] = 'basic';
    var_dump( modulaImport( array(), array(), NULL, $errore ) );
    var_dump( $errore );
