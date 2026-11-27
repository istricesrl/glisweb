<?php

    /**
     * esempio di pagesIndexAdd()
     *
     * L'output è controllato da _usr/_test/_tests/unit/menuUtilsCest.php. Si costruisce l'indice di una lingua con due
     * pagine che hanno lo stesso percorso, una al suo posto e una orfana, aggiunte in tutt'e due gli ordini: l'ultima
     * candidata, quella che il rewrite tiene, dev'essere sempre la pagina al suo posto. Un'orfana che è l'unica col suo
     * percorso dev'essere invece fra le candidate, perché nessuna pagina deve sparire.
     *
     */

    require '../../../../_src/_config.php';

    // output
    header( 'Content-type: text/plain' );

    // la pagina al suo posto prima dell'orfana
    $indice = array();
    pagesIndexAdd( $indice, 'contenuti', 'contenuti' );
    pagesIndexAdd( $indice, 'contenuti', 'contenuti.form', true );
    echo 'prima la dashboard: ' . end( $indice['contenuti'] ) . PHP_EOL;

    // l'orfana prima della pagina al suo posto
    $indice = array();
    pagesIndexAdd( $indice, 'contenuti', 'contenuti.form', true );
    pagesIndexAdd( $indice, 'contenuti', 'contenuti' );
    echo 'prima l\'orfana: ' . end( $indice['contenuti'] ) . PHP_EOL;

    // l'orfana da sola
    $indice = array();
    pagesIndexAdd( $indice, 'marchi', 'catalogo.marchi.form', true );
    echo 'orfana sola: ' . implode( ', ', $indice['marchi'] ) . PHP_EOL;
