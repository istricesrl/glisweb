<?php

    /**
     * esempio di pagesCheck()
     *
     * L'output è controllato da _usr/_test/_tests/unit/menuUtilsCest.php. Si controlla una struttura di pagine
     * costruita qui, che ha un genitore che non esiste, una linguetta che non esiste e due pagine sorelle con lo stesso
     * percorso in italiano; le pagine senza titolo o con forced in una lingua lì un percorso non ce l'hanno, e non
     * devono essere segnalate.
     *
     */

    require '../../../../_src/_config.php';

    // output
    header( 'Content-type: text/plain' );

    // pagine da controllare
    $pagine = array(
        'esempio.view'          => array( 'title' => array( 'it-IT' => 'esempio' ), 'parent' => array( 'id' => NULL ), 'etc' => array( 'tabs' => array( 'esempio.view', 'esempio.tools' ) ) ),
        'esempio.form'          => array( 'title' => array( 'it-IT' => 'scheda' ), 'parent' => array( 'id' => 'esempio.view' ) ),
        'esempio.form.testo'    => array( 'title' => array( 'it-IT' => 'testo' ), 'parent' => array( 'id' => 'esempio.form' ) ),
        'esempio.form.doppia'   => array( 'title' => array( 'it-IT' => 'contenuti' ), 'rewrited' => array( 'it-IT' => 'testo' ), 'parent' => array( 'id' => 'esempio.form' ) ),
        'esempio.form.orfana'   => array( 'title' => array( 'it-IT' => 'orfana' ), 'parent' => array( 'id' => 'esempio.inesistente' ) ),
        'esempio.senza.titolo'  => array( 'title' => array( 'it-IT' => NULL ), 'parent' => array( 'id' => 'esempio.form' ) ),
        'esempio.esterna'       => array( 'title' => array( 'it-IT' => 'testo' ), 'forced' => array( 'it-IT' => 'https://esempio.test/' ), 'parent' => array( 'id' => 'esempio.form' ) )
    );

    // controllo
    foreach( pagesCheck( $pagine, array( 'it-IT' ) ) as $problema ) {
        echo $problema . PHP_EOL;
    }

    // struttura sana
    $sane = array_slice( $pagine, 0, 3 );
    $sane['esempio.view']['etc']['tabs'] = array( 'esempio.view', 'esempio.form' );
    echo 'sana: ' . count( pagesCheck( $sane, array( 'it-IT' ) ) ) . PHP_EOL;
