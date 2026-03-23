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
    function memcacheFlush($conn, $allSites = false) {

        // validazione connessione
        if (!is_object($conn)) {
            logWrite('connessione al server assente o non valida per il flush', 'memcache');
            return false;
        }

        // seed obbligatorio
        if (!defined('MEMCACHE_UNIQUE_SEED') || trim((string) MEMCACHE_UNIQUE_SEED) === '') {
            logWrite('MEMCACHE_UNIQUE_SEED non definito o vuoto', 'memcache');
            return false;
        }

        // getAllKeys obbligatorio per questa implementazione
        if (!method_exists($conn, 'getAllKeys')) {
            logWrite('getAllKeys non disponibile su questa connessione', 'memcache');
            return false;
        }

        // recupero chiavi
        try {
            $keys = $conn->getAllKeys();
        } catch (\Throwable $e) {
            logWrite('eccezione in getAllKeys(): ' . $e->getMessage(), 'memcache');
            return false;
        }

        if (!is_array($keys)) {
            logWrite('getAllKeys() non ha restituito un array', 'memcache');
            return false;
        }

        if (empty($keys)) {
            logWrite('getAllKeys() non ha restituito alcuna chiave', 'memcache');
            return true;
        }

        /*
        * MODALITÀ DI MATCH
        *
        * 1) $allSites === false
        *    -> flush per seed corrente
        *       match: chiave che INIZIA con MEMCACHE_UNIQUE_SEED
        *
        * 2) $allSites è una stringa (es. "istricesrl.com")
        *    -> flush "per dominio"
        *       match:
        *          - chiave che INIZIA con DOMAIN_TOKEN
        *          - oppure chiave che contiene _DOMAIN_TOKEN
        *
        * Questo perché nel tuo caso reale esistono chiavi tipo:
        * BERNISPA_ISTRICESRL_COM_ISTRICESRL_COM_MYSQL_xxxxx
        * quindi "ISTRICESRL_COM_" non è necessariamente all'inizio.
        */

        $mode        = 'seed';
        $seedPrefix  = (string) MEMCACHE_UNIQUE_SEED;
        $seedLen     = strlen($seedPrefix);
        $domainToken = null;

        if ($allSites !== false) {
            $mode = 'domain';
            $domainToken = strtoupper(str_replace('.', '_', (string) $allSites)) . '_';
        }

        $batch       = [];
        $batchSize   = 500;

        $totalKeys   = count($keys);
        $validKeys   = 0;
        $matched     = 0;
        $deleted     = 0;
        $failed      = 0;

        // funzione di match centralizzata
        $matchesKey = function ($key) use ($mode, $seedPrefix, $seedLen, $domainToken) {

            if (!is_string($key) || $key === '') {
                return false;
            }

            if ($mode === 'seed') {
                return ($seedLen > 0 && strncmp($key, $seedPrefix, $seedLen) === 0);
            }

            // mode === 'domain'
            // match se:
            // - la chiave inizia esattamente con il token di dominio
            // - oppure contiene "_TOKEN" da qualche parte (tipico caso sottodominio + dominio)
            return (
                strpos($key, $domainToken) === 0 ||
                strpos($key, '_' . $domainToken) !== false
            );
        };

        // cancellazione batch con conteggio reale
        $deleteBatch = function(array $keysToDelete) use ($conn, &$deleted, &$failed) {

            if (empty($keysToDelete)) {
                return;
            }

            // Tentativo con deleteMulti, ma senza fidarsi ciecamente del risultato
            if (method_exists($conn, 'deleteMulti')) {
                try {
                    $result = $conn->deleteMulti($keysToDelete);

                    // Caso migliore: array di risultati per singola chiave
                    if (is_array($result)) {
                        foreach ($keysToDelete as $k) {
                            $ok = isset($result[$k]) ? (bool) $result[$k] : false;
                            if ($ok) {
                                $deleted++;
                            } else {
                                $failed++;
                            }
                        }
                        return;
                    }

                    // Se torna true/false globale, non ci fidiamo abbastanza:
                    // ripassiamo singolarmente per avere un conteggio vero.
                } catch (\Throwable $e) {
                    logWrite('eccezione in deleteMulti(): ' . $e->getMessage(), 'memcache');
                    // fallback al delete singolo
                }
            }

            // fallback o verifica reale
            foreach ($keysToDelete as $k) {
                try {
                    $ok = $conn->delete($k);
                    if ($ok) {
                        $deleted++;
                    } else {
                        $failed++;
                    }
                } catch (\Throwable $e) {
                    $failed++;
                    logWrite("eccezione in delete('{$k}'): " . $e->getMessage(), 'memcache');
                }
            }
        };

        // ciclo principale
        foreach ($keys as $k) {

            if (!is_string($k) || $k === '') {
                continue;
            }

            $validKeys++;

            if (!$matchesKey($k)) {
                continue;
            }

            $matched++;
            $batch[] = $k;

            if (count($batch) >= $batchSize) {
                $deleteBatch($batch);
                $batch = [];
            }
        }

        // coda finale
        if (!empty($batch)) {
            $deleteBatch($batch);
        }

        // info client memcache/memcached se disponibili
        $resultInfo = '';
        if (method_exists($conn, 'getResultCode') && method_exists($conn, 'getResultMessage')) {
            try {
                $resultInfo = ' resultCode=' . $conn->getResultCode() . ' resultMessage=' . $conn->getResultMessage();
            } catch (\Throwable $e) {
                // niente
            }
        }

        // log finale
        if ($mode === 'seed') {
            logWrite(
                "memcacheFlush mode=seed seed='{$seedPrefix}' totalKeys={$totalKeys} validKeys={$validKeys} matched={$matched} deleted={$deleted} failed={$failed}{$resultInfo}",
                'memcache'
            );
        } else {
            logWrite(
                "memcacheFlush mode=domain domain='{$allSites}' token='{$domainToken}' totalKeys={$totalKeys} validKeys={$validKeys} matched={$matched} deleted={$deleted} failed={$failed}{$resultInfo}",
                'memcache'
            );
        }

        /*
        * Semantica del return:
        * - false se ci sono state chiavi matchate ma nessuna è stata cancellata e ci sono fallimenti
        * - true negli altri casi
        *
        * In pratica:
        * - nessuna chiave da cancellare -> true
        * - alcune cancellate -> true
        * - tutte fallite -> false
        */
        if ($matched > 0 && $deleted === 0 && $failed > 0) {
            return false;
        }

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
