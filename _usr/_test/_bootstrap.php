<?php

    /**
     * bootstrap del framework per i test
     *
     * introduzione
     * ============
     * Questo file avvia il framework da riga di comando, per dare ai test ( e in particolare all'Helper
     * \Helper\Glisweb ) la configurazione e le funzioni del deploy: connessione al database, URL del sito,
     * memcache, passwordHash() e cosi' via. Non lo si include a mano: _src/_sh/_codeception.run.sh lo passa
     * a PHP come auto_prepend_file, perche' il bootstrap va eseguito nello scope globale ( $cf, $ct e $cx sono
     * globali, e le librerie li leggono con global ) e qualunque require fatto da Codeception finirebbe invece
     * dentro un metodo.
     *
     * richiesta simulata
     * ------------------
     * Il framework e' pensato per girare dietro Apache e ricava il sito dall'host della richiesta, quindi qui
     * si simula una richiesta HTTPS verso il deploy: l'host e' quello della variabile d'ambiente
     * GLISWEB_TEST_HOST o, se manca, il nome della cartella del deploy ( /var/www/<host>/dev ). Serve anche
     * SERVER_NAME, senza il quale _135.redirect.php risponde con un 301 e chiude, e una apache_request_headers()
     * vuota, che da riga di comando non esiste e _210.auth.php chiama.
     *
     * cosa espone ai test
     * -------------------
     * La variabile d'ambiente GLISWEB_TEST_URL, con l'URL del sito, che i file .suite.yml usano come
     * '%GLISWEB_TEST_URL%' per configurare PhpBrowser e WebDriver; tutto il resto lo prende l'Helper da $cf.
     *
     * sicurezza
     * ---------
     * Il file gira solo da riga di comando, e si rifiuta di andare avanti se il sito e' in produzione: i test
     * scrivono nel database ( account test-*, record TEST-E2E- ) e non devono farlo su dati veri.
     *
     */

    // solo da riga di comando
    if( PHP_SAPI !== 'cli' ) {
        die( 'questo file va eseguito da riga di comando' );
    }

    // host del deploy
    $testHost = ( getenv( 'GLISWEB_TEST_HOST' ) ) ? getenv( 'GLISWEB_TEST_HOST' ) : basename( dirname( dirname( dirname( __DIR__ ) ) ) );

    // richiesta simulata
    $_SERVER['HTTP_HOST']           = $testHost;
    $_SERVER['SERVER_NAME']         = $testHost;
    $_SERVER['SERVER_PORT']         = 443;
    $_SERVER['HTTPS']               = 'on';
    $_SERVER['REQUEST_METHOD']      = 'GET';
    $_SERVER['REQUEST_URI']         = '/';
    $_SERVER['REMOTE_ADDR']         = '127.0.0.1';

    // da riga di comando apache_request_headers() non esiste
    if( ! function_exists( 'apache_request_headers' ) ) {
        function apache_request_headers() {
            return array();
        }
    }

    // bootstrap del framework, scartando l'eventuale output
    ob_start();
    require dirname( dirname( __DIR__ ) ) . '/_src/_config.php';
    ob_end_clean();

    // la sessione aperta dal bootstrap non serve
    if( session_status() === PHP_SESSION_ACTIVE ) {
        session_write_close();
    }

    // niente test in produzione
    if( SITE_STATUS == PRODUCTION ) {
        fwrite( STDERR, 'il sito ' . $testHost . ' e\' in produzione, i test non si eseguono' . PHP_EOL );
        exit( 1 );
    }

    // URL del sito per i file .suite.yml
    $_SERVER['GLISWEB_TEST_URL'] = $_ENV['GLISWEB_TEST_URL'] = $cf['site']['url'];
    putenv( 'GLISWEB_TEST_URL=' . $cf['site']['url'] );
