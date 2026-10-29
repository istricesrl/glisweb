<?php

    /**
     * applicazione dei livelli di debug
     *
     * In questo file vengono applicati i livelli di debug impostati in
     * _src/_config/_000.debug.php e src/config/000.debug.php.
     *
     * applicazione della configurazione
     * =================================
     * Proseguendo nella lettura dei commenti si troverà che spesso i file di configurazione del framework sono
     * organizzati a coppie, il primo file che contiene soprattutto definizioni mentre il secondo che contiene il
     * codice inteso ad applicare i valori definiti dal primo. Questa strategia consente di personalizzare i valori
     * creando una copia custom del primo file, senza necessità di riscrivere le logiche contenute nel secondo.
     *
     * errori visualizzati da Apache
     * -----------------------------
     * Il livello degli errori visualizzati nell'output viene settato utilizzando la funzione ini_set()
     * (http://it1.php.net/manual/it/function.ini-set.php) sulla variabile diaplay_errors alla quale
     * viene assegnato il valore di $cf['debug']['lvl']['report'].
     *
     * la costante LOG_CURRENT_LEVEL
     * -----------------------------
     * Questa costante viene utilizzata per rappresentare il livello di log corrente, che influenza il comportamento
     * della funzione logger() definita in _src/_config.php.
     *
     */

    /**
     * applicazione delle configurazioni generali per il debug
     * =======================================================
     * In questa sezione vengono applicate le configurazioni generali per il debug relative ai timeout
     * di esecuzione e di connessione ai socket.
     * 
     * 
     */

    // tempo massimo di esecuzione
    ini_set( 'max_execution_time', $cf['debug']['run']['timeout'] );

    // timeout dei socket
    ini_set( 'default_socket_timeout', $cf['debug']['socket']['timeout'] );

    /**
     * configurazione del report degli errori a video
     * ==============================================
     * In questa sezione viene definito il comportamento del framework rispetto alla visualizzazione
     * degli errori tramite una chiamata a ini_set() sulla variabile display_errors e tramite
     * la funzione error_reporting() che imposta il livello di report degli errori. Vedi anche
     * https://www.php.net/manual/en/function.error-reporting.php.
     * 
     */

    // costante che descrive il livello corrente di report
    define( 'REPORT_CURRENT_LEVEL', $cf['debug'][ SITE_STATUS ]['report']['lvl'] );

    // determina se gli errori vengono mostrati o meno
    ini_set( 'display_errors', $cf['debug'][ SITE_STATUS ]['display'] );

    // determina quali errori vengono mostrati
    error_reporting( REPORT_CURRENT_LEVEL );

    /**
     * configurazione del log su file
     * ==============================
     * La costante LOG_CURRENT_LEVEL viene utilizzata per rappresentare il livello di log corrente,
     * che influenzando il comportamento della funzione logger() impatta sulla verbosità del log.
     * 
     */

    // costante per     logger() che descrive il livello corrente di log
    define( 'LOG_CURRENT_LEVEL', $cf['debug'][ SITE_STATUS ]['log']['lvl'] );

    /**
     * sorgente dei log remoti per i test
     * ==================================
     * Per la durata dei test _src/_sh/_codeception.run.sh scrive in var/test/log.remoti un segreto casuale, e qui
     * si aggiunge a debug.log.remoti.sorgenti la sorgente test-e2e con quel segreto, cosi' i test di /api/log e di
     * /api/aggiornamenti girano anche sui deploy che non hanno sorgenti. Come per var/test/recaptcha.off
     * ( _115.google.php ) non vale in produzione e scade dopo un'ora.
     *
     */

    // sorgente di prova durante i test
    if( substr( SITE_STATUS, 0, strlen( PRODUCTION ) ) != PRODUCTION && file_exists( DIR_VAR . 'test/log.remoti' ) && filemtime( DIR_VAR . 'test/log.remoti' ) > time() - 3600 ) {
        $cf['debug']['log']['remoti']['sorgenti']['test-e2e'] = array( 'segreto' => trim( file_get_contents( DIR_VAR . 'test/log.remoti' ) ) );
    }

    /**
     * log dei test in una cartella a parte
     * ====================================
     * Gli errori che i test provocano apposta ( login sbagliati, query su tabelle di prova, SMS senza server ) non devono
     * finire nei log del deploy, dove i controlli quotidiani li scambiano per guasti veri. Le richieste dei test portano
     * nello User-Agent il marcatore LOG_TEST_USER_AGENT, derivato dal segreto del giro in var/test/log.remoti ( un hash,
     * non il segreto, che vale anche per /api/log ): Chromium dall'argomento --user-agent dei .suite.yml, PhpBrowser
     * dall'intestazione della suite unit, restCall() dal processo dei test. Per quelle richieste, e per il processo di
     * Codeception stesso ( GLISWEB_TEST, _usr/_test/_bootstrap.php ), LOG_TEST vale true e logger() scrive in
     * var/log/test/. Si separa per richiesta e non per finestra di tempo, perché il traffico vero che arriva durante un
     * giro deve restare nei log del deploy. Come la sorgente di prova non vale in produzione e scade dopo un'ora; i log
     * scritti prima di questo runlevel restano nei file soliti.
     *
     */

    // marcatore delle richieste dei test
    if( isset( $cf['debug']['log']['remoti']['sorgenti']['test-e2e']['segreto'] ) ) {
        define( 'LOG_TEST_USER_AGENT', 'glisweb-test/' . substr( hash( 'sha256', 'user-agent' . $cf['debug']['log']['remoti']['sorgenti']['test-e2e']['segreto'] ), 0, 16 ) );
    }

    // log dei test a parte
    define( 'LOG_TEST', defined( 'LOG_TEST_USER_AGENT' ) && ( defined( 'GLISWEB_TEST' ) || strpos( $_SERVER['HTTP_USER_AGENT'] ?? '', LOG_TEST_USER_AGENT ) !== false ) );

    /**
     * debug del runlevel
     * ==================
     * Questa sezione contiene, commentate, alcune istruzioni di debug per questo runlevel.
     * 
     */

    // debug
    // echo 'OUTPUT';
