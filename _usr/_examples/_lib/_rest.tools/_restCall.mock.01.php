<?php

    /**
     * esempio di restCall() col finto REST dei test
     *
     * Chiama https://esempio.test/v1/ordini, che durante i test _src/_config/_595.rest.php fa deviare verso il finto
     * REST ( _usr/_test/_rest.mock.php ), e stampa status e risposta. Lo usa _usr/_test/_tests/unit/restToolsCest.php,
     * che prima prepara la risposta e dopo controlla la richiesta registrata. Fuori dai test esempio.test non esiste, e
     * la chiamata fallisce con status 0.
     *
     */

    require '../../../../_src/_config.php';

    $r = restCall( 'https://esempio.test/v1/ordini?apikey=K123', METHOD_POST, array( 'numero' => 7, 'password' => 'Segreta1' ), MIME_APPLICATION_JSON, MIME_APPLICATION_JSON, $status );

    echo 'status: ' . $status . PHP_EOL;
    echo 'risposta: ' . json_encode( $r, JSON_UNESCAPED_SLASHES ) . PHP_EOL;
