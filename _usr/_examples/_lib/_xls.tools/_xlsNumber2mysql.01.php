<?php

    /**
     * esempio di xlsNumber2mysql()
     *
     * L'output è controllato da _usr/_test/_tests/unit/xlsToolsCest.php. Si convertono numeri scritti all'italiana,
     * all'inglese, senza separatori e un valore numerico come lo restituisce una cella di tipo numero: fino al 2026-10-30
     * la funzione restituiva sempre NULL.
     *
     */

    require '../../../../_src/_config.php';

    // output
    header( 'Content-type: text/plain' );

    // numeri da convertire
    $numeri = array( '1.234,56', '1,234.56', '12,5', '12.5', '1234', 1234.5 );

    // conversione
    echo 'convertiti: ' . json_encode( array_map( 'xlsNumber2mysql', $numeri ) ) . PHP_EOL;
