<?php

    /**
     * endpoint di raccolta dei log remoti
     *
     * Chiamato in POST (JSON) da software che girano fuori dal deploy — un agent installato sul PC di un cliente,
     * un altro server, uno script — per lasciare le proprie tracce accanto a quelle del framework, dove le guardano
     * gli stessi controlli. Risponde a /api/log con il corpo:
     *
     *     {
     *         "sorgente": "<nome della sorgente>",
     *         "host": "<nome della macchina che scrive>",
     *         "righe": [
     *             { "livello": "info", "data": "2026-10-26 18:00:00", "canale": "<facoltativo>", "codifica": "base64", "messaggio": "..." },
     *             ...
     *         ]
     *     }
     *
     * e il segreto della sorgente nell'header gliswebLogKey. Il segreto NON passa da Authorization: Bearer, perche'
     * _src/_config/_210.auth.php lo intercetta come token JWT di login. Risponde:
     *
     *     { "status": "OK", "scritte": <n>, "scartate": <n> }
     *
     * Chi manda testo libero lo codifica: con "codifica": "base64" il messaggio e' la base64 del testo UTF-8 e
     * l'endpoint lo decodifica prima di scriverlo. Dove c'e' ModSecurity col Core Rule Set, un ritorno a capo seguito
     * da una parola, un '../' o un frammento di shell o di SQL nel corpo vengono letti come un attacco: la richiesta
     * prende 403 prima di arrivare qui, e ogni 403 da' punti all'IP del mittente nel firewall applicativo. Senza
     * "codifica" il messaggio si scrive com'e'; una codifica sconosciuta o una base64 non valida scartano la riga.
     *
     * Le sorgenti si dichiarano in debug.log.remoti.sorgenti.<nome>.segreto, nello shadow: ogni software ha il suo segreto,
     * revocabile da solo, e scrive solo nei suoi file. Le righe finiscono in
     *
     *     var/log/remoti/<host>/<sorgente>[.<canale>].<livello>.<anno e mese>.log
     *
     * nello stesso formato di logger(), con la data del mittente fra parentesi quadre dopo quella di arrivo: chi ha
     * una coda locale manda le righe in ritardo, e l'ora vera dell'evento e' la sua. Le righe NON passano dal filtro
     * di LOG_CURRENT_LEVEL, che e' la verbosita' del deploy e non del mittente: il livello minimo, se serve, si
     * sceglie per sorgente con debug.log.remoti.sorgenti.<nome>.livello ( default LOG_DEBUG, tutto ).
     *
     * L'endpoint e' raggiungibile da Internet, quindi passa dal limitatore del firewall, rateLimitCheck(), anche
     * prima di guardare il segreto ( debug.log.remoti.limite, default 120 richieste al minuto per IP ); accetta al piu'
     * debug.log.remoti.righe righe per richiesta ( default 100 ), tronca ogni messaggio a 4096 caratteri e smette di
     * scrivere in un file quando raggiunge debug.log.remoti.dimensione byte ( default 50 MB al mese ).
     *
     */

    // inclusione del framework
    if( ! defined( 'INCLUDE_SUBDIR' ) ) {
        require '../_config.php';
    } else {
        require INCLUDE_SUBDIR . '_config.php';
    }

    // dati in ingresso
    $data   = json_decode( file_get_contents( 'php://input' ), true );
    $result = array( 'status' => 'KO' );

    // configurazione, con i default
    $remoti = ( isset( $cf['debug']['log']['remoti'] ) && is_array( $cf['debug']['log']['remoti'] ) ) ? $cf['debug']['log']['remoti'] : array();
    $limite = array(
        'richieste' => ( isset( $remoti['limite']['richieste'] ) ) ? (int) $remoti['limite']['richieste'] : 120,
        'finestra'  => ( isset( $remoti['limite']['finestra'] ) )  ? (int) $remoti['limite']['finestra']  : 60
    );
    $maxRighe      = ( isset( $remoti['righe'] ) )      ? (int) $remoti['righe']      : 100;
    $maxDimensione = ( isset( $remoti['dimensione'] ) ) ? (int) $remoti['dimensione'] : 52428800;

    // segreto della richiesta; con HTTP/2 i nomi degli header arrivano in minuscolo
    $httpHeaders = array_change_key_case( apache_request_headers(), CASE_LOWER );
    $segreto     = ( isset( $httpHeaders['glisweblogkey'] ) ) ? $httpHeaders['glisweblogkey'] : NULL;

    // sorgente dichiarata
    $sorgente = ( is_array( $data ) && isset( $data['sorgente'] ) && is_string( $data['sorgente'] ) ) ? $data['sorgente'] : '';

    if( $_SERVER['REQUEST_METHOD'] !== 'POST' ) {

        // si scrive solo in POST
        http_response_code( 405 );
        $result['errore'] = 'metodo non consentito';

    } elseif( ! rateLimitCheck( 'log.remoti', $limite['richieste'], $limite['finestra'] ) ) {

        // troppe richieste dallo stesso IP, buone o cattive che siano
        http_response_code( 429 );
        $result['errore'] = 'troppe richieste';
        logger( 'richiesta della sorgente ' . $sorgente . ' rifiutata per limite di frequenza superato', 'log.remoti', LOG_WARNING );

    } elseif( ! preg_match( '/^[a-zA-Z0-9\.\-_]{1,64}$/', $sorgente ) || empty( $remoti['sorgenti'][ $sorgente ]['segreto'] ) || ! is_string( $segreto ) || ! hash_equals( (string) $remoti['sorgenti'][ $sorgente ]['segreto'], $segreto ) ) {

        // sorgente sconosciuta o segreto sbagliato: la stessa risposta, per non dire quali sorgenti esistono
        http_response_code( 401 );
        $result['errore'] = 'sorgente o segreto non validi';
        logger( 'richiesta rifiutata per sorgente o segreto non validi ( sorgente ' . substr( preg_replace( '/[^a-zA-Z0-9\.\-_]/', '_', $sorgente ), 0, 64 ) . ' )', 'log.remoti', LOG_WARNING );

    } elseif( ! isset( $data['righe'] ) || ! is_array( $data['righe'] ) || count( $data['righe'] ) > $maxRighe ) {

        // niente da scrivere, o troppo in una volta sola
        http_response_code( 400 );
        $result['errore'] = 'righe mancanti o piu\' di ' . $maxRighe;

    } else {

        // host del mittente: quello dichiarato, altrimenti l'IP; mai un percorso
        $host = ( isset( $data['host'] ) && is_string( $data['host'] ) && preg_match( '/^[a-zA-Z0-9\.\-_]{1,64}$/', $data['host'] ) ) ? $data['host'] : preg_replace( '/[^a-zA-Z0-9\.\-_]/', '_', $_SERVER['REMOTE_ADDR'] );

        // livello minimo della sorgente
        $minimo = ( isset( $remoti['sorgenti'][ $sorgente ]['livello'] ) ) ? (int) $remoti['sorgenti'][ $sorgente ]['livello'] : LOG_DEBUG;

        // nomi dei livelli, come in logger()
        $lvl = array( 0 => 'emerg', 1 => 'alert', 2 => 'crit', 3 => 'err', 4 => 'warning', 5 => 'notice', 6 => 'info', 7 => 'debug' );

        // cartella dell'host
        $cartella = DIR_VAR_LOG . 'remoti/' . $host . '/';
        checkPath( $cartella );

        $result = array( 'status' => 'OK', 'scritte' => 0, 'scartate' => 0 );

        foreach( $data['righe'] as $riga ) {

            // livello, per numero o per nome
            $l = NULL;
            if( isset( $riga['livello'] ) ) {
                if( is_int( $riga['livello'] ) && isset( $lvl[ $riga['livello'] ] ) ) {
                    $l = $riga['livello'];
                } elseif( is_string( $riga['livello'] ) && in_array( strtolower( $riga['livello'] ), $lvl ) ) {
                    $l = array_search( strtolower( $riga['livello'] ), $lvl );
                }
            }

            // canale facoltativo, sempre dentro i file della sorgente
            $canale = ( isset( $riga['canale'] ) && is_string( $riga['canale'] ) && preg_match( '/^[a-zA-Z0-9\-_]{1,32}$/', $riga['canale'] ) ) ? $sorgente . '.' . $riga['canale'] : $sorgente;

            // messaggio, in chiaro o codificato; false se la codifica non si conosce o non si decodifica
            $m = ( isset( $riga['messaggio'] ) && is_scalar( $riga['messaggio'] ) ) ? (string) $riga['messaggio'] : NULL;
            if( $m !== NULL && isset( $riga['codifica'] ) ) {
                $m = ( $riga['codifica'] === 'base64' ) ? base64_decode( $m, true ) : false;
            }

            if( $l === NULL || ! is_string( $m ) ) {

                // riga malformata
                $result['scartate']++;

            } elseif( $l > $minimo ) {

                // sotto il livello minimo della sorgente: non e' un errore, non si scrive e basta
                continue;

            } else {

                $file = $cartella . $canale . '.' . $lvl[ $l ] . '.' . date( 'Ym' ) . '.log';

                if( file_exists( $file ) && filesize( $file ) >= $maxDimensione ) {

                    // il file del mese e' pieno
                    $result['scartate']++;

                } else {

                    // data del mittente, se ne ha mandata una leggibile
                    $quando = ( isset( $riga['data'] ) && is_string( $riga['data'] ) && strtotime( $riga['data'] ) !== false ) ? ' [' . date( 'Y-m-d H:i:s', strtotime( $riga['data'] ) ) . ']' : '';

                    // messaggio su una riga sola, troncato
                    $m = substr( str_replace( array( "\r", "\n" ), ' ', $m ), 0, 4096 );

                    // NOTA non si usa logger() perche' filtra con LOG_CURRENT_LEVEL, la verbosita' del deploy; il formato e' il suo
                    file_put_contents( $file, date( 'Y-m-d H:i:s' ) . ' (' . $l . ')' . $quando . ' ' . $m . PHP_EOL, FILE_APPEND | LOCK_EX );
                    $result['scritte']++;

                }

            }

        }

    }

    // output
    buildJson( $result );
