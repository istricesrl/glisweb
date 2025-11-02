<?php

    /**
     * questo file contiene funzioni per l'utilizzo di Memcache
     *
     * Questa libreria è un wrapper per le funzioni di Memcache, che permette di utilizzare questa cache in modo coerente alle altre cache
     * supportate dal framework. In questo modo utilizzare una cache piuttosto che un'altra è abbastanza semplice una volta capita
     * la logica generale con cui sono strutturate le librerie di caching del framework.
     *
     * introduzione
     * ============
     * La cache Memcache è un tipo di cache chiave-valore abbastanza veloce (https://www.php.net/manual/it/book.memcache.php) molto utilizzata
     * nello sviluppo PHP. Il framework GlisWeb la sfrutta soprattutto per l'archiviazione di dati utilizzati frequentemente in modo da
     * velocizzare l'esperienza dell'utente.
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti proprie, ma richiede alcune costanti che devono essere definite in fase di configurazione
     * (vedi più avanti).
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in tre gruppi, le funzioni di utilità generale, quelle per la scrittura e quelle per
     * la lettura.
     * 
     * funzioni di utilità generale
     * ----------------------------
     * Queste funzioni consentono di semplificare alcune operazioni generali necessarie per il modo in cui il framework utilizza la
     * cache Memcache.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * memcacheUniqueKey()              | aggiunge un seme univoco alla chiave, per evitare collisioni fra siti diversi
     * memcacheAddKeyAgeSuffix()        | aggiunge il suffisso _AGE alla chiave, per memorizzare l'età della chiave
     * memcacheGetKeyAge()              | legge l'età di una chiave in cache
     *
     * funzioni per la scrittura dei dati
     * ----------------------------------
     * Queste funzioni riguardano specificamente le operazioni di scrittura e cancellazione dei dati in cache.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * memcacheWrite()                  | scrive un dato in cache
     * memcacheDelete()                 | cancella un dato dalla cache
     * memcacheFlush()                  | cancella tutti i dati dalla cache
     *
     * funzioni per la lettura dei dati
     * --------------------------------
     * Queste funzioni riguardano la lettura dei dati in cache.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * memcacheRead()                   | legge un dato dalla cache
     * 
     *
     * TODO documentare
     * TODO rinominare fileCachedExists() in memcacheFileExists() e fare funzione di retrocompatibilità
     * TODO rinominare fileGetCachedContents() in memcacheGetFileContents() e fare funzione di retrocompatibilità
     *
     */

    /**
     * FUNZIONI DI UTILITÀ GENERALE
     */

    /**
     *
     * TODO documentare
     *
     */
    function memcacheUniqueKey( &$k ) {

        if( strpos( $k, MEMCACHE_UNIQUE_SEED ) === false ) {
            $k = MEMCACHE_UNIQUE_SEED . $k;
        }

        return $k;

    }

    /**
     *
     * TODO documentare
     *
     */
    function memcacheAddKeyAgeSuffix( $k ) {

        if( substr( $k, -4 ) != '_AGE' ) {
            $k .= '_AGE';
        }

        return $k;

    }

    /**
     *
     * TODO documentare
     *
     */
    function memcacheGetKeyAge( $conn, $key ) {

        return memcacheRead( $conn, memcacheAddKeyAgeSuffix( $key ) );

    }

    /**
     * FUNZIONI PER LA SCRITTURA DEI DATI
     */

    /**
     *
     * TODO documentare
     *
     */
    function memcacheWrite( $conn, $key, $data, $ttl = MEMCACHE_DEFAULT_TTL ) {

        memcacheUniqueKey( $key );

        if( empty( $conn ) ) {

            logger( 'connessione al server assente per scrivere la chiave: ' . $key, 'memcache' );

            return false;

        } elseif( ! is_object( $conn ) ) {

            logger( 'connessione al server assente per scrivere la chiave: ' . $key, 'memcache' );

            return false;

        } else {

            $conn->setOption( Memcached::OPT_COMPRESSION, true );

            $r = $conn->set( $key, serialize( $data ), $ttl );

            if( $r === false ) {
                logger( 'impossibile (' . $conn->getResultCode() . ') scrivere la chiave: ' . $key, 'memcache', LOG_ERR );
            } else {
                logger( 'scrittura effettuata, chiave: ' . $key, 'memcache' );
                $r = $conn->set( memcacheAddKeyAgeSuffix( $key ), serialize( time() ), $ttl );
                if( $r === false ) {
                    logger( 'impossibile (' . $conn->getResultCode() . ') scrivere la chiave: ' . memcacheAddKeyAgeSuffix( $key ), 'memcache', LOG_ERR );
                } else {
                    logger( 'scrittura effettuata, chiave: ' . memcacheAddKeyAgeSuffix( $key ), 'memcache' );
                }
            }

            return $r;

        }

    }

    /**
     *
     * TODO documentare
     *
     */
    function memcacheDelete( $conn, $key, &$err = array() ) {

        memcacheUniqueKey( $key );

        if( empty( $conn ) ) {

        logWrite( 'connessione al server assente per eliminare la chiave: ' . $key, 'memcache' );

        return false;

        } elseif( ! is_object( $conn ) ) {

            logWrite( 'connessione al server assente per eliminare la chiave: ' . $key, 'memcache' );

            return false;

        } else {

            return $conn->delete( $key );

        }

    }

    /**
     *
     * NOTA vanno bloccate le scritture per almeno un secondo dopo il flush,
     * vedi http://php.net/manual/en/memcache.flush.php
     *
     * TODO documentare
     *
     */
    function memcacheFlush( $conn, $allSites = false ) {

        if (empty($conn) || !is_object($conn)) {
            logWrite('connessione al server assente per il flush', 'memcache');
            return false;
        }

        if (!defined('MEMCACHE_UNIQUE_SEED') || MEMCACHE_UNIQUE_SEED === '') {
            logWrite('MEMCACHE_UNIQUE_SEED non definito o vuoto', 'memcache');
            return false;
        }

        if (!method_exists($conn, 'getAllKeys')) {
            logWrite('getAllKeys non disponibile su questa connessione', 'memcache');
            return false;
        }

        $keys = @$conn->getAllKeys();

        if (!is_array($keys) || empty($keys)) {
            logWrite('getAllKeys fallita o nessuna chiave presente', 'memcache');
            return false;
        }

        $prefix    = (string) ( $allSites === false ) ? MEMCACHE_UNIQUE_SEED : strtoupper( str_replace( '.', '_', $allSites ) ) . '_';
        $prefixLen = strlen($prefix);
        $batch     = [];
        $deleted   = 0;
        $batchSize = 500;

        foreach ($keys as $k) {

            if (!is_string($k)) {
                continue;
            }

            if (strpos($k, $prefix) !== false) {

                $batch[] = $k;

                if (count($batch) >= $batchSize) {
                    if (method_exists($conn, 'deleteMulti')) {
                        @ $conn->deleteMulti($batch);
                        $deleted += count($batch);
                    } else {
                        foreach ($batch as $bk) {
                            if (@$conn->delete($bk)) {
                                $deleted++;
                            }
                        }
                    }
                    $batch = [];
                }

            }

        }

        if (!empty($batch)) {

            if (method_exists($conn, 'deleteMulti')) {
                @ $conn->deleteMulti($batch);
                $deleted += count($batch);
            } else {
                foreach ($batch as $bk) {
                    if (@$conn->delete($bk)) {
                        $deleted++;
                    }
                }
            }

        }

        logWrite("flush per prefisso '{$prefix}': eliminate {$deleted} chiavi", 'memcache');

        return true;

    }

    /**
     * FUNZIONI PER LA LETTURA DEI DATI
     */

    /**
     *
     * https://www.php.net/manual/en/memcached.getresultcode.php
     * 
     * TODO documentare
     *
     */
    function memcacheRead( $conn, $key, &$err = array() ) {

        memcacheUniqueKey( $key );

        // Connessione valida?
        if (!($conn instanceof Memcached)) {
            logger('connessione al server assente per leggere la chiave: ' . $key, 'memcache');
            $err = Memcached::RES_FAILURE;
            return false;
        }

        // Lettura
        $value = $conn->get($key);
        $code  = $conn->getResultCode();
        $err   = $code;

        if ($code !== Memcached::RES_SUCCESS) {
            // RES_NOTFOUND, RES_TIMEOUT, ecc.
            logger('impossibile (' . $code . ') leggere la chiave: ' . $key, 'memcache');
            return false;
        }

        // Se è stringa "probabilmente serializzata", prova a deserializzare una sola volta
        if (is_string($value) && $value !== '' && preg_match('/^(?:a|O|s|i|d|b|N|C):/', $value)) {
            $un = @unserialize($value);
            if ($un !== false || $value === 'b:0;' || $value === 'N;') {
                return $un;
            }
        }

        // Valore grezzo (stringa non serializzata, numeri, array già nativo se usi igbinary, bool, ecc.)
        logger('lettura effettuata, chiave: ' . $key, 'memcache');
        return $value;

    }

    /**
     *
     * TODO questa funzione andrebbe resa generalista e salvata in una libreria tipo cache utils in modo da usare
     * fra le varie cache possiili quella attiva
     * 
     * TODO documentare
     *
     */
    function fileCachedExists( $m, $f, $t = MEMCACHE_DEFAULT_TTL, &$err = array() ) {

        if( ! empty( $m ) ) {

            if( empty( $err ) ) {
                $err = Memcached::RES_FAILURE;
            }

            $k = 'FILE_CACHED_EXISTS_' . md5( $f );

            $r = memcacheRead( $m, $k, $err );

            if( $r === false ) {
                $r = fileExists( $f );
                if( $r === false ) {
                    $r = -1;
                }
                memcacheWrite( $m, $k, $r, $t );
            } elseif( $r === -1 ) {
                $r = false;
            }

        } else {

            $r = fileExists( $f );

        }

        return $r;

    }

    /**
     *
     * 
     * TODO questa funzione andrebbe resa generalista e salvata in una libreria tipo cache utils in modo da usare
     * fra le varie cache possiili quella attiva
     * 
     * 
     * TODO documentare
     *
     */
    function fileGetCachedContents( $m, $f, $t = MEMCACHE_DEFAULT_TTL, &$err = array() ) {

        if( ! empty( $m ) ) {

            if( empty( $err ) ) {
                $err = Memcached::RES_FAILURE;
            }

            $k = md5( $f );

            $r = memcacheRead( $m, $k, $err );

            if( empty( $r ) || $r === false ) {
                $r = file_get_contents( $f );
                memcacheWrite( $m, $k, $r, $t );
            }

        } else {

            $r = file_get_contents( $f );

        }

        return $r;

    }
