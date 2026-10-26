<?php

    /**
     * endpoint di distribuzione degli aggiornamenti dei software esterni
     *
     * Chiamato in GET dai software che girano fuori dal deploy — un agent installato sul PC di un cliente — per sapere
     * se c'e' una versione nuova e scaricarla, cosi' un aggiornamento si fa pubblicando un file sul deploy invece che
     * chiedendo al cliente di installarlo. Risponde a /api/aggiornamenti:
     *
     *     ?sorgente=<nome>              { "status": "OK", "versione": "0.1.8", "sha256": "...", "firma": "...", "dimensione": <byte> }
     *     ?sorgente=<nome>&scarica=1    il file, in application/octet-stream
     *
     * col segreto della sorgente nell'header gliswebLogKey: le sorgenti sono le stesse dei log remoti
     * ( debug.log.remoti.sorgenti.<nome>.segreto, vedi _src/_api/_log.php ), un'identita' per software.
     *
     * Il materiale si pubblica in var/spool/aggiornamenti/<sorgente>/, che Apache non serve direttamente
     * ( .htaccess, var/spool/ ): il file e il manifest.json
     *
     *     { "versione": "0.1.8", "file": "agent.exe", "sha256": "<hash del file>", "firma": "<base64>" }
     *
     * La firma NON la controlla questo endpoint, e non la puo' fare il deploy: e' una firma Ed25519 di
     * "<sorgente>\n<versione>\n<sha256>" fatta con una chiave privata che sul server non c'e', e la verifica il
     * software con la chiave pubblica che porta con se'. Chi riuscisse a scrivere in var/spool/aggiornamenti/ potrebbe
     * pubblicare un file, ma non un file che il software accetti; qui si controlla solo che il file corrisponda
     * all'hash del manifest, per non servire un file pubblicato a meta'.
     *
     * Passa dal limitatore del firewall, rateLimitCheck(), prima di guardare il segreto ( debug.log.remoti.limite,
     * come i log remoti ).
     *
     */

    // inclusione del framework
    if( ! defined( 'INCLUDE_SUBDIR' ) ) {
        require '../_config.php';
    } else {
        require INCLUDE_SUBDIR . '_config.php';
    }

    // risposta di default
    $result = array( 'status' => 'KO' );

    // configurazione, con i default
    $remoti = ( isset( $cf['debug']['log']['remoti'] ) && is_array( $cf['debug']['log']['remoti'] ) ) ? $cf['debug']['log']['remoti'] : array();
    $limite = array(
        'richieste' => ( isset( $remoti['limite']['richieste'] ) ) ? (int) $remoti['limite']['richieste'] : 120,
        'finestra'  => ( isset( $remoti['limite']['finestra'] ) )  ? (int) $remoti['limite']['finestra']  : 60
    );

    // segreto della richiesta; con HTTP/2 i nomi degli header arrivano in minuscolo
    $httpHeaders = array_change_key_case( apache_request_headers(), CASE_LOWER );
    $segreto     = ( isset( $httpHeaders['glisweblogkey'] ) ) ? $httpHeaders['glisweblogkey'] : NULL;

    // sorgente richiesta
    $sorgente = ( isset( $_GET['sorgente'] ) && is_string( $_GET['sorgente'] ) ) ? $_GET['sorgente'] : '';

    // materiale pubblicato
    $cartella = DIR_VAR_SPOOL . 'aggiornamenti/' . $sorgente . '/';
    $manifest = NULL;

    if( $_SERVER['REQUEST_METHOD'] !== 'GET' ) {

        // si legge soltanto
        http_response_code( 405 );
        $result['errore'] = 'metodo non consentito';

    } elseif( ! rateLimitCheck( 'aggiornamenti', $limite['richieste'], $limite['finestra'] ) ) {

        // troppe richieste dallo stesso IP
        http_response_code( 429 );
        $result['errore'] = 'troppe richieste';
        logger( 'richiesta della sorgente ' . substr( preg_replace( '/[^a-zA-Z0-9\.\-_]/', '_', $sorgente ), 0, 64 ) . ' rifiutata per limite di frequenza superato', 'aggiornamenti', LOG_WARNING );

    } elseif( ! preg_match( '/^[a-zA-Z0-9\.\-_]{1,64}$/', $sorgente ) || empty( $remoti['sorgenti'][ $sorgente ]['segreto'] ) || ! is_string( $segreto ) || ! hash_equals( (string) $remoti['sorgenti'][ $sorgente ]['segreto'], $segreto ) ) {

        // sorgente sconosciuta o segreto sbagliato: la stessa risposta, per non dire quali sorgenti esistono
        http_response_code( 401 );
        $result['errore'] = 'sorgente o segreto non validi';
        logger( 'richiesta rifiutata per sorgente o segreto non validi ( sorgente ' . substr( preg_replace( '/[^a-zA-Z0-9\.\-_]/', '_', $sorgente ), 0, 64 ) . ' )', 'aggiornamenti', LOG_WARNING );

    } elseif( ! file_exists( $cartella . 'manifest.json' ) ) {

        // niente di pubblicato per questa sorgente
        http_response_code( 404 );
        $result['errore'] = 'nessun aggiornamento pubblicato';

    } elseif( ! is_array( $manifest = json_decode( file_get_contents( $cartella . 'manifest.json' ), true ) )
        || empty( $manifest['versione'] ) || empty( $manifest['file'] ) || empty( $manifest['sha256'] ) || empty( $manifest['firma'] )
        || basename( $manifest['file'] ) !== $manifest['file'] || ! file_exists( $cartella . $manifest['file'] ) ) {

        // manifest rotto o file mancante: e' un errore di chi ha pubblicato
        http_response_code( 500 );
        $result['errore'] = 'aggiornamento pubblicato non valido';
        logger( 'manifest di ' . $sorgente . ' non valido o file mancante in ' . $cartella, 'aggiornamenti', LOG_ERR );

    } elseif( ! hash_equals( strtolower( $manifest['sha256'] ), hash_file( 'sha256', $cartella . $manifest['file'] ) ) ) {

        // file diverso da quello dichiarato, p.es. copiato a meta'
        http_response_code( 503 );
        $result['errore'] = 'aggiornamento in pubblicazione, riprovare';
        logger( 'il file di ' . $sorgente . ' non corrisponde all\'hash del manifest', 'aggiornamenti', LOG_ERR );

    } elseif( empty( $_GET['scarica'] ) ) {

        // il manifest, per decidere se scaricare
        $result = array(
            'status'     => 'OK',
            'versione'   => (string) $manifest['versione'],
            'sha256'     => strtolower( $manifest['sha256'] ),
            'firma'      => (string) $manifest['firma'],
            'dimensione' => filesize( $cartella . $manifest['file'] )
        );

    } else {

        // log
        logger( 'scaricamento della versione ' . $manifest['versione'] . ' di ' . $sorgente . ' da ' . $_SERVER['REMOTE_ADDR'], 'aggiornamenti', LOG_NOTICE );

        // NOTA come in _src/_api/_download.php: senza chiudere il buffer gzip del bootstrap readfile() terrebbe in memoria l'intero file
        while( ob_get_level() > 0 ) {
            ob_end_clean();
        }

        // header
        header( 'content-type: application/octet-stream' );
        header( 'Content-Length: ' . filesize( $cartella . $manifest['file'] ) );

        // download
        set_time_limit( 0 );
        readfile( $cartella . $manifest['file'] );
        exit;

    }

    // output
    buildJson( $result );
