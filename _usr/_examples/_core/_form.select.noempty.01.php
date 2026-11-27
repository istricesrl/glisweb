<?php

    /**
     * esempio della chiave field.noempty della macro select() di _src/_twig/_lib/_form.twig
     *
     * L'output è controllato da _usr/_test/_tests/unit/twigFormCest.php. Senza noempty la selectbox statica si apre con
     * un'opzione vuota, e finché non si sceglie il campo resta vuoto; con noempty l'opzione vuota non c'è e il browser
     * preseleziona la prima, che per una tendina di un solo valore è l'unica. Fino al 24/11/2026 l'opzione vuota
     * guardava la variabile noempty, che nella macro non esiste, e il flag toglieva solo l'attributo empty.
     *
     */

    require '../../../_src/_config.php';

    // la macro come la importano i template
    $tw = new \Twig\Environment( new \Twig\Loader\ArrayLoader( array(
        'select' => "{% import '_lib/_form.twig' as frm %}{{ frm.select( { 'form': { 'table': 'prova' }, 'field': { 'name': 'id_scelta', 'noempty': noempty }, 'source': { 'values': valori } } ) }}"
    ) ), array( 'cache' => false ) );
    $tw->setLoader( new \Twig\Loader\ChainLoader( array( $tw->getLoader(), new \Twig\Loader\FilesystemLoader( DIR_BASE . '_src/_twig/' ) ) ) );

    // una tendina di due valori, senza e con noempty
    $valori = array( array( 'id' => 1, '__label__' => 'uno' ), array( 'id' => 2, '__label__' => 'due' ) );
    foreach( array( '', 1 ) as $noempty ) {
        $html = $tw->render( 'select', array( 'noempty' => $noempty, 'valori' => $valori ) );
        echo 'noempty=' . var_export( $noempty, true ) . ' opzione vuota: ' . ( strpos( $html, '<option value=""></option>' ) === false ? 'no' : 'si' ) . ', attributo empty: ' . ( preg_match( '/\sempty\s*>/', $html ) ? 'si' : 'no' ) . ', opzioni: ' . substr_count( $html, '<option ' ) . PHP_EOL;
    }
