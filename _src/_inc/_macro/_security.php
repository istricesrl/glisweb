<?php

    /**
     * firewall applicativo del framework
     *
     * introduzione
     * ============
     *
     * Il firewall applicativo gira a ogni richiesta, prima di qualsiasi altra cosa del framework, e deve reggere da
     * solo: il framework può girare senza ModSecurity e senza fail2ban, e allora riconoscere un attacco, bandirne la
     * sorgente e respingerla a basso costo sono cose che fa lui.
     *
     * Bloccare una richiesta e bandire una sorgente sono due decisioni diverse. Bloccare costa poco anche quando è
     * sbagliato; bandire costa moltissimo, perché dietro un IP ci sono un ufficio, un ospedale, un operatore mobile.
     * Fino al 30/09/2026 le due cose erano un gesto solo, e una parola di tre lettere trovata per caso dentro un gclid
     * ha tenuto fuori più di milletrecento utenti veri, per mesi. Quindi:
     *
     * - ogni regola attiva che scatta blocca la richiesta e dà all'IP il suo peso in punti;
     * - l'IP viene bandito quando arriva a SECURITY_SCORE_LIMIT punti in SECURITY_SCORE_WINDOW secondi, e il bando
     *   dura di più se ci ricasca entro SECURITY_RECIDIVE_TTL ( i gradini sono in SECURITY_BAN_STEPS );
     * - alla fine della richiesta anche un 404 su un percorso da scanner dà punti ( securityOutcome() ).
     *
     * Le funzioni stanno in _src/_config.php ( securityRules(), securityCheck(), securityBan() e le altre ), perché
     * questo file gira prima delle librerie; i punti sono un canale di rateLimitCheck().
     *
     *
     * le regole
     * =========
     *
     * Le regole stanno in _etc/_security/_firewall.rules.conf e, per il deploy, in etc/security/firewall.rules.conf,
     * letto dopo: una regola del deploy con la stessa zona, lo stesso tipo e lo stesso valore di una standard la
     * sostituisce, e con lo stato off la spegne. Una regola per riga, cinque campi separati da spazi:
     *
     *     stato  zona   tipo  peso  valore
     *     on     uri    str   10    ../..
     *     obs    ua     str   10    sqlmap
     *
     * - stato: on ( attiva ), obs ( in osservazione: la corrispondenza si annota nel registro dell'IP ma la richiesta
     *   passa ), off ( spenta ); una regola nuova nasce obs e diventa on dopo qualche giorno di registri puliti;
     * - zona: path, query, uri ( percorso e querystring ), body ( i valori della POST e il corpo delle richieste non
     *   form ), ua ( lo User-Agent ), valore ( i valori di primo livello della $_REQUEST );
     * - tipo: str ( sottostringa ), word ( parola intera ), re ( espressione regolare completa di delimitatori ), eq
     *   ( uguaglianza stretta, solo per la zona valore );
     * - valore: il resto della riga, spazi compresi; str e word non distinguono maiuscole e minuscole.
     *
     * Il vecchio elenco _etc/_security/_banned.words.conf è ancora letto: una parola semplice vale 10 nel percorso e 2
     * come parola intera nella querystring, le altre valgono 10 nell'URL e 10 come valore della $_REQUEST.
     *
     * Le regole si collaudano con _src/_sh/_security.test.sh, che rigioca un elenco di richieste con l'esito atteso.
     *
     *
     * lo stato
     * ========
     *
     * Tutto in var/spool/security/, un file per IP:
     *
     * - ban/\<ip\>: esiste finché l'IP è bandito, con la scadenza come data di ultima modifica; lo controlla anche la
     *   regola in testa al .htaccess, che respinge l'IP bandito senza far partire PHP;
     * - \<ip\>.log: il registro degli attacchi, con ogni richiesta bloccata, ogni bando e ogni sblocco;
     * - limiti/firewall/\<ip\>.log e limiti/firewall.bandi.\<n\>/\<ip\>.log: i punti e i bandi, registri di rateLimitCheck();
     * - resoconti/\<data\>.txt: i resoconti del task notturno _src/_api/_task/_security.clean.php.
     *
     * Il vecchio registro banned.hosts.conf, se c'è, viene migrato alla prima richiesta e rinominato. Dietro un proxy o
     * un CDN REMOTE_ADDR è l'indirizzo del proxy: va attivato mod_remoteip, che lo corregge sia per PHP sia per Apache.
     *
     *
     * chi non viene mai bandito, e come si esce da un bando sbagliato
     * ================================================================
     *
     * La richiesta con una regola attiva viene bloccata sempre, ma l'IP non viene bandito se è la macchina stessa, se
     * sta in etc/security/allowed.hosts.conf ( un IP o una rete CIDR per riga ) o se è un crawler verificato col DNS.
     *
     * L'IP bandito vede la pagina dell'accesso sospeso, che rimanda alla pagina di sblocco ( security.sblocco, in
     * _src/_inc/_pages/_security.*.php ): con una verifica reCAPTCHA toglie il bando, al massimo una volta ogni
     * SECURITY_UNBAN_INTERVAL secondi. Ogni sblocco è un falso positivo segnalato da solo, e il resoconto notturno lo
     * mette fra gli allarmi.
     *
     *
     * limiti di frequenza
     * ===================
     *
     * Per gli endpoint pubblici che costano qualcosa a ogni richiesta c'è rateLimitCheck(), definita in
     * _src/_config.php: se torna false l'endpoint rifiuta la richiesta ( di norma con HTTP 429 ). Superare un limite
     * non dà punti e non bandisce. Utilizzatori: _src/_api/_emailable.verifica.php e _src/_api/_emailable.scarti.php.
     *
     *
     * avvertenze importanti
     * =====================
     *
     * - nessun elenco di regole sostituisce le query preparate e l'escaping: SQL injection e XSS si chiudono nel codice
     * - questo file è richiamato da _src/_config.php quindi se un file del framework non usa _src/_config.php deve
     *   includerlo manualmente
     *
     *
     */

    // durata dei bandi del vecchio registro, usata per migrarlo ( sette giorni )
    if( ! defined( 'SECURITY_BAN_TTL' ) ) {
        define( 'SECURITY_BAN_TTL', 604800 );
    }

    // gradini del bando: un'ora, un giorno, sette giorni
    if( ! defined( 'SECURITY_BAN_STEPS' ) ) {
        define( 'SECURITY_BAN_STEPS', array( 3600, 86400, 604800 ) );
    }

    // punti che fanno scattare il bando, e finestra in cui si sommano ( un'ora )
    if( ! defined( 'SECURITY_SCORE_LIMIT' ) ) {
        define( 'SECURITY_SCORE_LIMIT', 10 );
    }
    if( ! defined( 'SECURITY_SCORE_WINDOW' ) ) {
        define( 'SECURITY_SCORE_WINDOW', 3600 );
    }

    // finestra entro cui un nuovo bando conta come recidiva ( trenta giorni )
    if( ! defined( 'SECURITY_RECIDIVE_TTL' ) ) {
        define( 'SECURITY_RECIDIVE_TTL', 2592000 );
    }

    // intervallo minimo fra due sblocchi con verifica umana dello stesso IP ( un giorno )
    if( ! defined( 'SECURITY_UNBAN_INTERVAL' ) ) {
        define( 'SECURITY_UNBAN_INTERVAL', 86400 );
    }

    // durata dei registri degli IP ( novanta giorni )
    if( ! defined( 'SECURITY_LOG_TTL' ) ) {
        define( 'SECURITY_LOG_TTL', 7776000 );
    }

    // percorsi che, se rispondono 404, sono quelli che cerca uno scanner: script, copie, configurazioni e i file
    // nascosti che contano; un punto dopo la barra da solo no, perché un'immagine senza nome è un asset rotto
    define( 'SECURITY_PROBE_PATHS'                      , '/(\.(php\d?|phtml|asp|aspx|jsp|cgi|pl|env|git|svn|sql|bak|old|ini|ya?ml|swp)$)|\/\.(env|git|svn|hg|aws|ssh|htaccess|htpasswd|DS_Store|vscode|idea)(\/|$)/i' );

    // percorsi della pagina di sblocco, che l'IP bandito deve poter raggiungere ( gli stessi sono nel .htaccess )
    define( 'SECURITY_UNBAN_PATHS'                      , '/^\/(sblocco-accesso\.it-IT|unlock-access\.en-GB)\.html$/' );

    // da riga di comando non c'è una sorgente
    if( empty( $_SERVER['REMOTE_ADDR'] ) ) {
        return;
    }

    // controllo che esista la cartella per i log di sicurezza
    checkPath( DIR_VAR_SPOOL_SECURITY );

    // migrazione del vecchio registro: la rinomina è atomica, quindi la fa una richiesta sola
    $migrato = DIR_VAR_SPOOL_SECURITY . 'banned.hosts.migrato.' . date( 'YmdHis' ) . '.conf';
    if( file_exists( FILE_BANNED_HOSTS ) && @rename( FILE_BANNED_HOSTS, $migrato ) && checkPath( DIR_VAR_SPOOL_SECURITY_BAN ) ) {
        foreach( file( $migrato, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES ) as $row ) {
            $row = explode( ' ', trim( $row ) );
            $log = DIR_VAR_SPOOL_SECURITY . $row[0] . '.log';
            $ts = ( isset( $row[1] ) ) ? (int) $row[1] : ( ( file_exists( $log ) ) ? filemtime( $log ) : 0 );
            if( filter_var( $row[0], FILTER_VALIDATE_IP ) !== false && $ts + SECURITY_BAN_TTL > time() ) {
                file_put_contents( DIR_VAR_SPOOL_SECURITY_BAN . $row[0], 'migrato da banned.hosts.conf' . PHP_EOL );
                touch( DIR_VAR_SPOOL_SECURITY_BAN . $row[0], $ts + SECURITY_BAN_TTL );
            }
        }
    }

    // l'IP bandito vede l'accesso sospeso, tranne sulla pagina che lo sblocca
    $banned = DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'];
    if( file_exists( $banned ) && filemtime( $banned ) > time() && ! preg_match( SECURITY_UNBAN_PATHS, strtok( $_SERVER['REQUEST_URI'], '?' ) ) ) {
        http_response_code( 429 );
        header( 'Retry-After: ' . ( filemtime( $banned ) - time() ) );
        header( 'Content-type: text/plain; charset=utf-8' );
        die( 'accesso sospeso, per sbloccarlo: /sblocco-accesso.it-IT.html' . PHP_EOL . 'access suspended, to unlock it: /unlock-access.en-GB.html' );
    }

    // corpo grezzo, solo per le richieste che non sono form ( JSON, XML ): per i form basta la $_POST
    $raw = '';
    if( ! empty( $_SERVER['CONTENT_TYPE'] ) && ! preg_match( '/^(application\/x-www-form-urlencoded|multipart\/form-data)/i', $_SERVER['CONTENT_TYPE'] ) ) {
        $raw = (string) @file_get_contents( 'php://input', false, NULL, 0, 65536 );
    }

    // regole che corrispondono: quelle in osservazione si annotano e basta, quelle attive si sommano
    $matches = array();
    $points = 0;
    foreach( securityCheck( securityRules(), $_SERVER['REQUEST_URI'], $_POST, ( ( isset( $_SERVER['HTTP_USER_AGENT'] ) ) ? $_SERVER['HTTP_USER_AGENT'] : '' ), $_REQUEST, $raw ) as $rule ) {
        if( $rule['stato'] == 'obs' ) {
            securityLog( 'osservazione per la regola ' . $rule['zona'] . ':' . $rule['tipo'] . ':' . $rule['valore'] );
        } else {
            $matches[] = $rule['zona'] . ':' . $rule['tipo'] . ':' . $rule['valore'];
            $points += $rule['peso'];
        }
    }

    // la richiesta con una regola attiva si blocca sempre; l'IP si bandisce solo se arriva alla soglia
    if( ! empty( $matches ) ) {

        // punti ed eventuale bando
        $esito = securityBan( $points, implode( ' ', $matches ) );
        securityLog( 'match per la regola ' . implode( ' ', $matches ) . ( ( ! empty( $esito ) ) ? ', ' . $esito : '' ) );

        // HTTP status di risposta
        http_response_code( 400 );

        // output
        header( 'Content-type: text/plain' );
        die( 'richiesta bloccata' );

    }

    // l'esito della richiesta si guarda alla fine
    register_shutdown_function( 'securityOutcome' );
