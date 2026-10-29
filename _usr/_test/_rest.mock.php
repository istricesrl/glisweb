<?php

    /**
     * finto REST per i test automatici
     *
     * introduzione
     * ============
     * Molti progetti parlano con gestionali e servizi che non hanno un ambiente di prova: da DEV una scrittura arriva
     * sui dati veri. Durante i test quelle chiamate vengono quindi deviate qui ( vedi restMockUrl() in
     * _src/_lib/_rest.tools.php e _src/_config/_595.rest.php ), e questo file risponde come gli hanno detto i test e
     * registra cosa gli e' arrivato, perche' i test possano verificare cosa sarebbe partito verso il servizio vero.
     *
     * come gira
     * ---------
     * Lo avvia _src/_sh/_codeception.run.sh all'inizio del giro, col server integrato di PHP su 127.0.0.1 a una porta
     * libera, e lo spegne alla fine; non risponde a nient'altro che al server integrato, quindi aperto da Apache non fa
     * niente. Il percorso della richiesta comincia con l'host a cui era diretta la chiamata, p.es.
     * /api.esempio.test/v1/ordini.
     *
     * risposte e richieste
     * --------------------
     * Tutto sta in var/test/rest.mock.d/, e lo scrive e lo legge l'helper \Helper\RestMock:
     *
     * file                         | contenuto
     * -----------------------------|--------------------------------------------------------------
     * risposte/NNNN.json           | una regola per file: metodo ( o * ), host ( o vuoto per tutti ), espressione
     *                              | regolare sul percorso, status e risposta; vince la prima regola che corrisponde
     * richieste.jsonl              | una riga per richiesta: ora, metodo, host, percorso, query e corpo, con le
     *                              | credenziali mascherate da restMaskSecrets(); gli header non si registrano
     *
     * Una richiesta senza regola riceve un 404 con un JSON che lo dice, cosi' un test che si e' dimenticato una
     * risposta fallisce invece di passare per caso.
     *
     */

    // solo dal server integrato di PHP
    if( PHP_SAPI !== 'cli-server' ) {
        die( 'questo file lo avvia _src/_sh/_codeception.run.sh' );
    }

    // restMaskSecrets(), da una libreria che vuole logger() anche se qui non serve
    function logger() {}
    require dirname( dirname( __DIR__ ) ) . '/_src/_lib/_rest.tools.php';

    // cartella del finto REST
    $cartella = dirname( dirname( __DIR__ ) ) . '/var/test/rest.mock.d/';

    // host e percorso della chiamata originale
    $uri = parse_url( $_SERVER['REQUEST_URI'] );
    $parti = explode( '/', ltrim( $uri['path'], '/' ), 2 );
    $host = $parti[0];
    $percorso = '/' . ( ( isset( $parti[1] ) ) ? $parti[1] : '' );
    $metodo = $_SERVER['REQUEST_METHOD'];

    // corpo, decodificato se e' JSON
    $corpo = file_get_contents( 'php://input' );
    $json = json_decode( $corpo, true );

    // registrazione della richiesta, senza header e con le credenziali mascherate
    file_put_contents(
        $cartella . 'richieste.jsonl',
        json_encode( array(
            'ora' => date( 'Y-m-d H:i:s' ),
            'metodo' => $metodo,
            'host' => $host,
            'percorso' => $percorso,
            'query' => restMaskSecrets( ( isset( $uri['query'] ) ) ? $uri['query'] : '' ),
            'corpo' => restMaskSecrets( ( $json !== NULL ) ? $json : $corpo )
        ), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES ) . PHP_EOL,
        FILE_APPEND | LOCK_EX
    );

    // risposta secondo la prima regola che corrisponde
    header( 'Content-Type: application/json' );
    foreach( glob( $cartella . 'risposte/*.json' ) as $f ) {
        $r = json_decode( file_get_contents( $f ), true );
        if( ( $r['metodo'] === '*' || $r['metodo'] === $metodo ) && ( empty( $r['host'] ) || $r['host'] === $host ) && preg_match( $r['percorso'], $percorso ) ) {
            http_response_code( $r['status'] );
            echo json_encode( $r['risposta'], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES );
            exit;
        }
    }

    // nessuna regola
    http_response_code( 404 );
    echo json_encode( array( 'errore' => 'nessuna risposta preparata per ' . $metodo . ' ' . $host . $percorso ), JSON_UNESCAPED_SLASHES );
