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
     * GLISWEB_TEST_HOST o, se manca, il nome della cartella del deploy ( /var/www/<host>/dev ); in questo secondo caso
     * si definisce GLISWEB_TEST_AUTO, e se la cartella ha il nome dell'host di produzione di un sito
     * _src/_config/_015.site.php passa all'host DEV ( o TEST ) dello stesso sito. Serve anche
     * SERVER_NAME, senza il quale _135.redirect.php risponde con un 301 e chiude, e una apache_request_headers()
     * vuota, che da riga di comando non esiste e _210.auth.php chiama.
     *
     * cosa espone ai test
     * -------------------
     * La variabile d'ambiente GLISWEB_TEST_URL, con l'URL del sito, che i file .suite.yml usano come
     * '%GLISWEB_TEST_URL%' per configurare PhpBrowser e WebDriver; tutto il resto lo prende l'Helper da $cf.
     * La variabile GLISWEB_TEST_USER_AGENT, lo User-Agent col marcatore che fa scrivere al sito i log dei test in
     * var/log/test/ ( vedi _src/_config/_020.debug.php ), che i .suite.yml usano come '%GLISWEB_TEST_USER_AGENT%'.
     *
     * sicurezza
     * ---------
     * Il file gira solo da riga di comando, e si rifiuta di andare avanti se il sito e' in produzione: i test
     * scrivono nel database ( account test-*, record TEST-E2E- ) e non devono farlo su dati veri. Il controllo
     * lo fa _src/_config/_015.site.php appena ricavato lo status, grazie alla costante GLISWEB_TEST, cioe' prima
     * di qualunque connessione: fino al 16/10/2026 lo si faceva qui dopo il bootstrap, e su crm.trbitaly.com, senza
     * GLISWEB_TEST_HOST, il nome della cartella aveva portato i test a collegarsi al database di produzione.
     *
     */

    // solo da riga di comando
    if( PHP_SAPI !== 'cli' ) {
        die( 'questo file va eseguito da riga di comando' );
    }

    // segnala al framework che lo avviano i test ( vedi _src/_config/_015.site.php )
    define( 'GLISWEB_TEST', true );

    // host del deploy
    $testHost = ( getenv( 'GLISWEB_TEST_HOST' ) ) ? getenv( 'GLISWEB_TEST_HOST' ) : basename( dirname( dirname( dirname( __DIR__ ) ) ) );

    // host ricavato dalla cartella ( vedi _src/_config/_015.site.php )
    if( ! getenv( 'GLISWEB_TEST_HOST' ) && ! defined( 'GLISWEB_TEST_AUTO' ) ) {
        define( 'GLISWEB_TEST_AUTO', true );
    }

    // richiesta simulata
    $_SERVER['HTTP_HOST']           = $testHost;
    $_SERVER['SERVER_NAME']         = $testHost;
    $_SERVER['SERVER_PORT']         = 443;
    $_SERVER['HTTPS']               = 'on';
    $_SERVER['REQUEST_METHOD']      = 'GET';
    // Fix 2026-10-13: non '/', perche' un redirect da database su '/' ( _135.redirect.php ) fa exit e il bootstrap muore muto
    $_SERVER['REQUEST_URI']         = '/__test__';
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

    // niente test in produzione ( ogni stato che comincia per PROD )
    if( substr( SITE_STATUS, 0, strlen( PRODUCTION ) ) == PRODUCTION ) {
        fwrite( STDERR, 'il sito ' . $testHost . ' e\' in produzione, i test non si eseguono' . PHP_EOL );
        exit( 1 );
    }

    // connessioni al database tenute aperte per tutta la suite: il wait_timeout del server ( 60 s su mysql03 ) e' pensato
    // per le richieste web, mentre qui la connessione del bootstrap resta ferma finche' il browser lavora, e se fra due
    // chiamate dell'helper passa piu' di un minuto le query muoiono con 2006, o grabFromDatabase() torna vuoto senza errori; da PHP 7.3 mysqli_ping() non riconnette
    foreach( ( isset( $cf['mysql']['connections'] ) ? $cf['mysql']['connections'] : array() ) as $cn ) {
        mysqlQuery( $cn, 'SET SESSION wait_timeout = 28800' );
    }

    // URL del sito per i file .suite.yml
    $_SERVER['GLISWEB_TEST_URL'] = $_ENV['GLISWEB_TEST_URL'] = $cf['site']['url'];
    putenv( 'GLISWEB_TEST_URL=' . $cf['site']['url'] );

    // User-Agent col marcatore dei test per i file .suite.yml e per restCall(): senza _codeception.run.sh non c'e' il
    // segreto del giro, e lo User-Agent resta senza marcatore
    $ua = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome' . ( defined( 'LOG_TEST_USER_AGENT' ) ? ' ' . LOG_TEST_USER_AGENT : '' );
    $_SERVER['GLISWEB_TEST_USER_AGENT'] = $_ENV['GLISWEB_TEST_USER_AGENT'] = $ua;
    putenv( 'GLISWEB_TEST_USER_AGENT=' . $ua );

    // porta di chromedriver per i file .suite.yml: la sceglie _codeception.run.sh fra quelle libere, cosi' due deploy
    // della stessa macchina possono far girare i test insieme; senza lo script vale la 9515 di sempre
    $porta = getenv( 'GLISWEB_CHROMEDRIVER_PORT' ) ?: '9515';
    $_SERVER['GLISWEB_CHROMEDRIVER_PORT'] = $_ENV['GLISWEB_CHROMEDRIVER_PORT'] = $porta;
    putenv( 'GLISWEB_CHROMEDRIVER_PORT=' . $porta );
