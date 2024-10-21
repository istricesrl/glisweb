<?php

    /**
     * variabili di utilità generale
     *
     * In questo file vanno dichiarate le variabili di varia utilità.
     *
     * utilizzo della chiave common
     * ============================
     * La scelta di raggruppare le chiavi di varia utilità sotto l'unica chiave common è dettata in primo luogo dalla necessità
     * di tenere pulito il primo livello di $cf evitando di moltiplicare le chiavi. Sotto la chiave common trovano posto
     * tutte le informazioni utili ma non essenziali che possono essere necessarie durante l'esecuzione del framework e che
     * non hanno una collocazione specifica proprio in ragione della loro comune utilità.
     *
     * lorem ipsum
     * -----------
     * 
     * TODO documentare il file _etc/_common/_lorem.conf
     *
     * codici di stato HTTP
     * --------------------
     *
     *
     *
     *
     *
     * licenza commerciale
     * -------------------
     * Il framework GlisWeb è totalmente Open Source e gratuito, e lo rimarrà sempre. La presenza di una licenza commerciale
     * non comporta differenze nel codice, nelle funzionalità o in qualsiasi altro aspetto del framework, ma dà semplicemente
     * accesso all'assistenza di Fabio Mosti <fabio.mosti@istricesrl.it> e degli sviluppatori di Istrice srl che si occupano
     * di manutenere e aggiornare il software. Se siete titolari di una licenza commerciale, potete inviare le vostre richieste
     * di assistenza all'ufficio Produzione di Istricesrl <produzione@istricesrl.it>; mentre se non disponete di una licenza
     * commerciale e siete interessati a procurarvene una potete diventare nostri sostenitori su GitHub (all'indirizzo
     * https://github.com/istricesrl/glisweb) oppure contattare l'ufficio Commerciale di Istrice srl <commerciale@istricesrl.it>.
     *
     * versione del framework e controllo aggiornamenti
     * ------------------------------------------------
     * Il framework segue due distinte linee di versionamento: la versione e la release. La release è un indicatore a tre cifre
     * (es. 1.1.1) che indica il livello di sviluppo raggiunto dal ramo master del framework e viene incrementato manualmente ogni
     * volta che viene fatto il merge di una release branch su master; in effetti una delle attività da fare nella release
     * branch è quella di incrementare la release nel file /_etc/_current.release.
     * 
     * La release indica anche il livello di compatibilità con le release precedenti; si osservi la seguente tabella:
     * 
     * cifra        | ruolo                   | retrocompatibilità
     * -------------|-------------------------|-----------------------------------------------------------
     * I            | major release           | non retrocompatibile
     * II           | minor release           | retrocompatibile con la stessa major release
     * III          | patch release           | retrocompatibile con la stessa major e minor release
     * 
     * La versione invece viene incrementata automaticamente ogni volta che si effettua un push su una qualunque branch del
     * repository, e indica pertanto in linea di massima quando il codice è stato aggiornato l'ultima volta; la versione può essere
     * vista come un indicatore del livello di patch dell'installazione corrente. La versione è un numero intero formato dalla
     * data corrente in formato YYYYMMDDHHIISS (anno, mese, giorno, ora, minuti, secondi) e come detto sopra viene incrementato
     * automaticamente tramite uno script che viene eseguito ad ogni push e salvata nel file _etc/_current.version.
     *
     *
     *
     * link alla documentazione
     * ------------------------
     *
     * TODO documentare come viene gestita e compilata la documentazione del framework, spiegare Doxygen e il file _etc/_doxygen/_doxygen.conf
     *
     *
     *
     *
     * TODO documentare
     *
     *
     *
     */

    /**
     * utilità varie
     * =============
     * 
     * 
     */

    // variabile che contiene un paragrafo di testo finto (lorem ipsum)
    $cf['common']['lorem']['std'] = readStringFromFile( FILE_LOREM );

    // codici di stato HTTP
    $cf['common']['http']['codes'] = array(
        100 => 'Continue',                          101 => 'Switching Protocols',                   102 => 'Processing',
        200 => 'OK',                                201 => 'Created',                               202 => 'Accepted',
        203 => 'Non-Authoritative Information',     204 => 'No Content',                            205 => 'Reset Content',
        206 => 'Partial Content',                   207 => 'Multi-Status',                          300 => 'Multiple Choices',
        301 => 'Moved Permanently',                 302 => 'Found',                                 303 => 'See Other',
        304 => 'Not Modified',                      305 => 'Use Proxy',                             306 => '(Unused)',
        307 => 'Temporary Redirect',                308 => 'Permanent Redirect',                    400 => 'Bad Request',
        401 => 'Unauthorized',                      402 => 'Payment Required',                      403 => 'Forbidden',
        404 => 'Not Found',                         405 => 'Method Not Allowed',                    406 => 'Not Acceptable',
        407 => 'Proxy Authentication Required',     408 => 'Request Timeout',                       409 => 'Conflict',
        410 => 'Gone',                              411 => 'Length Required',                       412 => 'Precondition Failed',
        413 => 'Request Entity Too Large',          414 => 'Request-URI Too Long',                  415 => 'Unsupported Media Type',
        416 => 'Requested Range Not Satisfiable',   417 => 'Expectation Failed',                    418 => 'I\'m a teapot',
        419 => 'Authentication Timeout',            420 => 'Enhance Your Calm',                     422 => 'Unprocessable Entity',
        423 => 'Locked',                            424 => 'Failed Dependency',                     424 => 'Method Failure',
        425 => 'Unordered Collection',              426 => 'Upgrade Required',                      428 => 'Precondition Required',
        429 => 'Too Many Requests',                 431 => 'Request Header Fields Too Large',       444 => 'No Response',
        449 => 'Retry With',                        450 => 'Blocked by Windows Parental Controls',  451 => 'Unavailable For Legal Reasons',
        494 => 'Request Header Too Large',          495 => 'Cert Error',                            496 => 'No Cert',
        497 => 'HTTP to HTTPS',                     499 => 'Client Closed Request',                 500 => 'Internal Server Error',
        501 => 'Not Implemented',                   502 => 'Bad Gateway',                           503 => 'Service Unavailable',
        504 => 'Gateway Timeout',                   505 => 'HTTP Version Not Supported',            506 => 'Variant Also Negotiates',
        507 => 'Insufficient Storage',              508 => 'Loop Detected',                         509 => 'Bandwidth Limit Exceeded',
        510 => 'Not Extended',                      511 => 'Network Authentication Required',       598 => 'Network read timeout error',
        599 => 'Network connect timeout error'
    );

    /** 
     * link alla documentazione
     * ========================
     * 
     * 
     * 
     * TODO decidere come gestire la documentazione
     * sarebbe bello avere un bel manuale su Google Docs che gli utenti possono utilizzare per imparare a usare il CMS del framework,
     * e una documentazione tecnica in formato HTML e PDF che gli sviluppatori possono consultare per capire come funziona il framework
     * 

    // link al manuale utente
    $cf['common']['docs']['user']['html'] = array(
        'url' => 'https://s-url.it/gliswebdocs',
        'name' => array( 'it-IT' => 'su Google Docs' )
    );

    // link alla documentazione tecnica in formato HTML
    $cf['common']['docs']['tech']['html'] = array(
        'url' => $cf['site']['url'] . FILE_MANUAL_HTML
    );

    // link alla documentazione tecnica in formato PDF
    $cf['common']['docs']['tech']['pdf'] = array(
        'url' => $cf['site']['url'] . FILE_MANUAL_PDF
    );

    */

    /* TODO a che epoca risale questa cosa? non sembra essere usata da nessuna parte

    // ...
    $cf['anagrafica'] = array();

    // ...
    if( isset( $cx['anagrafica'] ) ) {
        $cf['anagrafica'] = array_replace_recursive( $cf['anagrafica'], $cx['anagrafica'] );
    }

    // ...
    $ct['anagrafica']                    = &$cf['anagrafica'];

    */

    /**
     * verifica versione e release
     * ===========================
     * 
     * 
     */

    // controllo aggiornamento release
    if( ! checkFileConsistency( FILE_LATEST_RELEASE, '-1 week' ) ) {

        // recupero l'ultima release da glisweb.istricesrl.it
        $latestRelease = restGetString( 'https://glisweb.istricesrl.it/current.release' );

        // scrivo l'ultima release su file
        writeToFile( $latestRelease, FILE_LATEST_RELEASE );

    }

    // controllo aggiornamento versione
    if( ! checkFileConsistency( FILE_LATEST_VERSION ) ) {

        // recupero l'ultima versione da glisweb.istricesrl.it
        $latestVersion = restGetString( 'https://glisweb.istricesrl.it/current.version' );

        // scrivo l'ultima versione su file
        writeToFile( $latestVersion, FILE_LATEST_VERSION );

    }

    // versione corrente del framework
    $cf['common']['version']['current'] = trim( readStringFromFile( FILE_CURRENT_VERSION ) );

    // release corrente del framework
    $cf['common']['release']['current'] = trim( readStringFromFile( FILE_CURRENT_RELEASE ) );

    // costante per la versione corrente del framework
    define( 'VERSION_CURRENT', $cf['common']['version']['current'] );

    // costante per la versione corrente del framework
    define( 'RELEASE_CURRENT', $cf['common']['release']['current'] );

    // versione aggiornata del framework
    $cf['common']['version']['latest'] = trim( readStringFromFile( FILE_LATEST_VERSION ) );

    // release aggiornata del framework
    $cf['common']['release']['latest'] = trim( readStringFromFile( FILE_LATEST_RELEASE ) );

    // costante per la versione aggiornata del framework
    define( 'VERSION_LATEST', $cf['common']['version']['latest'] );

    // costante per la release aggiornata del framework
    define( 'RELEASE_LATEST', $cf['common']['release']['latest'] );

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // dieText( print_r( $cf['common'], true ) );
    // echo 'OUTPUT';
