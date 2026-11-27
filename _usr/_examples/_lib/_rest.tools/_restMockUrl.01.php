<?php

    /**
     * esempio di restMockUrl()
     *
     * L'output è controllato da _usr/_test/_tests/unit/restToolsCest.php: un host elencato viene deviato verso il finto
     * REST con host, percorso e query, anche se scritto in maiuscolo; un host non elencato e un URL illeggibile restano
     * come sono.
     *
     */

    require '../../../../_src/_config.php';

    $mock = 'http://127.0.0.1:8790';
    $hosts = array( 'api.esempio.test' );

    echo restMockUrl( 'https://api.esempio.test/v1/ordini?id=7', $mock, $hosts ) . PHP_EOL;
    echo restMockUrl( 'https://API.Esempio.test', $mock, $hosts ) . PHP_EOL;
    echo restMockUrl( 'https://altro.esempio.test/v1/ordini', $mock, $hosts ) . PHP_EOL;
    echo restMockUrl( 'non e un url', $mock, $hosts ) . PHP_EOL;
