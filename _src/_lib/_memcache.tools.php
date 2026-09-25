<?php

    /**
     * libreria per l'utilizzo di Memcache
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
     * Nonostante il nome, la libreria usa l'estensione Memcached di PHP ( la classe Memcached ) e non la vecchia estensione
     * Memcache; la connessione viene aperta al runlevel _src/_config/_045.cache.php e si trova in $cf['memcache']['connection'].
     * Tutte le funzioni ricevono le chiavi nude e vi aggiungono da sole il seme del sito corrente, e le scritture tengono
     * aggiornato un indice delle chiavi ( la chiave CACHE_INDEX ) che permette di svuotare la cache di un sito senza toccare
     * quella degli altri siti che condividono lo stesso server.
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
     * funzioni per i file in cache
     * ----------------------------
     * Queste funzioni usano la cache per evitare di ripetere verifiche e letture di file.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * fileCachedExists()               | verifica se un file esiste, usando la cache
     * fileGetCachedContents()          | legge il contenuto di un file, usando la cache
     * 
     * dipendenze
     * ==========
     * Questa libreria richiede alcune costanti, definite ai runlevel _src/_config/_040.cache.php e _src/_config/_045.cache.php:
     * 
     * costante                 | spiegazione
     * -------------------------|--------------------------------------------------------------
     * MEMCACHE_UNIQUE_SEED     | un seme univoco per la chiave, che permette di evitare collisioni fra siti diversi
     * MEMCACHE_DEFAULT_TTL     | il tempo di vita di default di una chiave in cache, in secondi ( 0 per nessuna scadenza )
     * 
     * Sono richieste inoltre le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logger()                         | core
     * logWrite()                       | _src/_lib/_log.utils.php
     * fileExists()                     | _src/_lib/_filesystem.tools.php
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     * TODO rinominare fileCachedExists() in memcacheFileExists() e fare funzione di retrocompatibilità
     * TODO rinominare fileGetCachedContents() in memcacheGetFileContents() e fare funzione di retrocompatibilità
     *
     */

    /**
     * FUNZIONI DI UTILITÀ GENERALE
     */

    /**
     * aggiunge un seme univoco alla chiave, per evitare collisioni fra siti diversi
     *
     * Questa funzione antepone alla chiave il seme MEMCACHE_UNIQUE_SEED, che identifica il sito corrente, in modo che siti
     * diversi che condividono lo stesso server Memcached non leggano e scrivano le chiavi l'uno dell'altro; se il seme compare
     * già nella chiave ( in qualsiasi posizione, non solo in testa ) la chiave non viene modificata, per cui chiamare la
     * funzione più volte sulla stessa chiave è innocuo. Tutte le funzioni di lettura e scrittura della libreria la chiamano da
     * sole: il chiamante passa sempre la chiave nuda.
     *
     * @param       string      $k      la chiave da modificare, modificata sul posto
     *
     * @return      string              la chiave con il seme
     *
     */
    function memcacheUniqueKey(&$k)
    {

        if (strpos($k, MEMCACHE_UNIQUE_SEED) === false) {
            $k = MEMCACHE_UNIQUE_SEED . $k;
        }

        return $k;
    }

    /**
     * aggiunge il suffisso _AGE alla chiave, per memorizzare l'età della chiave
     *
     * Questa funzione aggiunge il suffisso _AGE alla chiave, se non lo ha già, in modo da ottenere il nome della chiave che
     * memorizza l'età di un'altra chiave, facilmente associabile alla chiave originale.
     *
     * @param       string      $k      la chiave da modificare
     *
     * @return      string              la chiave con il suffisso _AGE
     *
     */
    function memcacheAddKeyAgeSuffix($k)
    {

        if (substr($k, -4) != '_AGE') {
            $k .= '_AGE';
        }

        return $k;
    }

    /**
     * legge l'età di una chiave in cache
     *
     * Questa funzione legge l'età di una chiave in cache, cioè il valore della chiave con lo stesso nome e il suffisso _AGE
     * ( vedi memcacheAddKeyAgeSuffix() ), che memcacheWrite() scrive insieme al dato con il timestamp della scrittura; se
     * questa non esiste restituisce false. I chiamanti ( i runlevel _310.pages.php dei moduli dei contenuti ) confrontano
     * il timestamp di aggiornamento di una pagina con questo valore, e la rigenerano se è più recente.
     *
     * Se è definita la costante MEMCACHE_REFRESH ( la definisce _src/_api/_task/_memcache.clean.php ) la funzione
     * restituisce false, così che il refresh forzato rigeneri tutte le pagine anche quando una chiave è sfuggita al flush
     * perché mancava dall'indice CACHE_INDEX; senza questo accorgimento la pagina resterebbe quella in cache ( 2026-09-24 ).
     *
     * @param       object      $conn   la connessione a Memcached
     * @param       string      $key    la chiave di cui leggere l'età, senza il seme
     *
     * @return      mixed               il valore della chiave _AGE, oppure false se non esiste o se è in corso un refresh
     *
     */
    function memcacheGetKeyAge($conn, $key)
    {

        if (defined('MEMCACHE_REFRESH')) {
            return false;
        }

        return memcacheRead($conn, memcacheAddKeyAgeSuffix($key));
    }

    /**
     * FUNZIONI PER LA SCRITTURA DEI DATI
     */

    /**
     * scrive un dato in cache
     *
     * Questa funzione serializza il dato e lo scrive in cache con la chiave indicata ( a cui aggiunge il seme del sito ) e con
     * la compressione attiva; se la scrittura riesce scrive anche la chiave _AGE con il timestamp corrente e lo stesso TTL
     * ( vedi memcacheGetKeyAge(); la chiave _AGE non entra nell'indice ) e aggiorna l'indice delle chiavi del sito, la chiave
     * CACHE_INDEX, che associa a ogni chiave il momento della scrittura e il TTL, ed è quello che memcacheFlush() usa per
     * sapere cosa cancellare.
     * Se la connessione è assente o non è un oggetto la funzione logga l'errore e restituisce false senza scrivere niente.
     *
     * TODO l'indice viene riscritto con il TTL dell'ultima chiave scritta: una chiave con TTL breve fa scadere l'indice prima
     * delle altre chiavi, che da quel momento memcacheFlush() non vede più. La lettura e la riscrittura dell'indice inoltre non
     * sono atomiche, quindi due scritture contemporanee possono perdere una voce.
     *
     * @param       object      $conn   la connessione a Memcached
     * @param       string      $key    la chiave con cui scrivere il dato, senza il seme
     * @param       mixed       $data   il dato da scrivere
     * @param       int         $ttl    il tempo di vita della chiave in secondi ( default MEMCACHE_DEFAULT_TTL, 0 per nessuna scadenza )
     *
     * @return      bool                true se sono stati scritti sia il dato sia l'indice, false altrimenti
     *
     */
    function memcacheWrite($conn, $key, $data, $ttl = MEMCACHE_DEFAULT_TTL)
    {

        memcacheUniqueKey($key);

        if (empty($conn)) {

            logger('connessione al server assente per scrivere la chiave: ' . $key, 'memcache');

            return false;
        } elseif (! is_object($conn)) {

            logger('connessione al server assente per scrivere la chiave: ' . $key, 'memcache');

            return false;
        } else {

            $conn->setOption(Memcached::OPT_COMPRESSION, true);

            $r = $conn->set($key, serialize($data), $ttl);

            if ($r === false) {
                logger('impossibile (' . $conn->getResultCode() . ') scrivere la chiave: ' . $key, 'memcache', LOG_ERR);
            } else {
                // la chiave _AGE con il momento della scrittura, come in apcuWrite() e redisWrite(); era stata tolta il
                // 2026-03-26 insieme all'arrivo dell'indice, e memcacheGetKeyAge() restituiva sempre false ( 2026-09-24 )
                if ($conn->set(memcacheAddKeyAgeSuffix($key), serialize(time()), $ttl) === false) {
                    logger('impossibile (' . $conn->getResultCode() . ') scrivere la chiave: ' . memcacheAddKeyAgeSuffix($key), 'memcache', LOG_ERR);
                }
                $idxKey = 'CACHE_INDEX';
                $m = memcacheRead($conn, memcacheUniqueKey($idxKey));
                if (!is_array($m)) {
                    $m = [];
                }
                $m[$key] = array('time' => time(), 'ttl' => $ttl);
                $r = $conn->set(memcacheUniqueKey($idxKey), serialize($m), $ttl);
                if ($r === false) {
                    logger('impossibile (' . $conn->getResultCode() . ') aggiornare l\'indice dopo aver scritto la chiave: ' . $key, 'memcache', LOG_ERR);
                }
            }

            return $r;
        }
    }

    /**
     * cancella un dato dalla cache
     *
     * Questa funzione cancella dalla cache la chiave indicata, a cui aggiunge il seme del sito; se la connessione è assente o
     * non è un oggetto logga l'errore e restituisce false. La chiave non viene tolta dall'indice CACHE_INDEX, per cui un
     * successivo memcacheFlush() proverà a cancellarla di nuovo e la conterà fra quelle già assenti.
     *
     * @param       object      $conn   la connessione a Memcached
     * @param       string      $key    la chiave da cancellare, senza il seme
     * @param       array       $err    non utilizzato
     *
     * @return      bool                true se la chiave è stata cancellata, false altrimenti ( anche se la chiave non esisteva )
     *
     */
    function memcacheDelete($conn, $key, &$err = array())
    {

        memcacheUniqueKey($key);

        if (empty($conn)) {

            logWrite('connessione al server assente per eliminare la chiave: ' . $key, 'memcache');

            return false;
        } elseif (! is_object($conn)) {

            logWrite('connessione al server assente per eliminare la chiave: ' . $key, 'memcache');

            return false;
        } else {

            return $conn->delete($key);
        }
    }

    /**
     * cancella tutti i dati dalla cache
     *
     * Questa funzione cancella dalla cache le chiavi elencate nell'indice CACHE_INDEX del sito corrente ( vedi memcacheWrite() ),
     * una per una, invece di svuotare l'intero server, e poi riscrive l'indice senza le chiavi cancellate; le chiavi già
     * assenti ( scadute o cancellate in altro modo ) non contano come errori. Con $allSites a false vengono cancellate solo le
     * chiavi che cominciano con il seme del sito corrente; il parametro però non allarga la portata, perché l'indice che si
     * legge è comunque quello del sito corrente ( per i dettagli e per la pulizia di tutti i siti del deploy si vedano i
     * commenti al file _src/_api/_task/_memcache.clean.php ).
     *
     * La funzione restituisce false se la connessione non è valida, se MEMCACHE_UNIQUE_SEED non è definita o è vuota, se la
     * lettura dell'indice solleva un'eccezione, o se almeno una cancellazione o la riscrittura dell'indice falliscono; un
     * indice vuoto, o senza chiavi che passano il filtro, restituisce true.
     *
     * NOTA vanno bloccate le scritture per almeno un secondo dopo il flush,
     * vedi http://php.net/manual/en/memcache.flush.php
     *
     * @param       object      $conn       la connessione a Memcached
     * @param       bool        $allSites   true per non filtrare le chiavi sul seme del sito corrente ( default false )
     *
     * @return      bool                    true se tutte le chiavi sono state cancellate o erano già assenti, false altrimenti
     *
     */
    function memcacheFlush($conn, $allSites = false)
    {

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

        // recupero indice chiavi
        try {
            $idxKey = 'CACHE_INDEX';
            $indexKey = memcacheUniqueKey($idxKey);
            $m = memcacheRead($conn, $indexKey);

            if (!is_array($m)) {
                $m = [];
            }

            $keys = array_keys($m);
        } catch (\Throwable $e) {
            logWrite('eccezione in memcacheRead(): ' . $e->getMessage(), 'memcache', LOG_ERR);
            return false;
        }

        if (empty($keys)) {
            logWrite('flush: nessuna chiave presente nell\'indice', 'memcache');
            return true;
        }

        $toDelete = [];
        foreach ($keys as $key) {
            if ($allSites || strpos($key, MEMCACHE_UNIQUE_SEED) === 0) {
                $toDelete[] = $key;
            }
        }

        if (empty($toDelete)) {
            logWrite('flush: nessuna chiave compatibile con il filtro selezionato', 'memcache');
            return true;
        }

        $total = count($toDelete);
        $deleted = 0;
        $notFound = 0;
        $failed = 0;

        foreach ($toDelete as $key) {
            $del = $conn->delete($key);

            if ($del === false) {
                $errCode = $conn->getResultCode();

                // Memcached::RES_NOTFOUND = 16
                if (
                    (defined('Memcached::RES_NOTFOUND') && $errCode === Memcached::RES_NOTFOUND)
                    || $errCode === 16
                ) {
                    logWrite('chiave già assente (' . $errCode . '): ' . $key, 'memcache');
                    $notFound++;
                } else {
                    logWrite('impossibile (' . $errCode . ') eliminare la chiave: ' . $key, 'memcache', LOG_ERR);
                    $failed++;
                }
            } else {
                logWrite('chiave eliminata: ' . $key, 'memcache');
                $deleted++;
            }

            // pulizia indice locale
            unset($m[$key]);
        }

        // aggiorno l'indice
        try {
            // qui assumo che memcacheWrite() gestisca correttamente la serializzazione
            memcacheWrite($conn, $indexKey, $m);
        } catch (\Throwable $e) {
            logWrite('eccezione nell\'aggiornamento dell\'indice: ' . $e->getMessage(), 'memcache', LOG_ERR);
            $failed++;
        }

        logWrite(
            'flush completato: processate ' . $total .
                ', eliminate ' . $deleted .
                ', già assenti ' . $notFound .
                ', errori reali ' . $failed,
            'memcache',
            $failed > 0 ? LOG_ERR : LOG_INFO
        );

        return ($failed === 0);
    }

    /**
     * FUNZIONI PER LA LETTURA DEI DATI
     */

    /**
     * legge un dato dalla cache
     *
     * Questa funzione legge dalla cache la chiave indicata, a cui aggiunge il seme del sito, e se il valore è una stringa
     * serializzata ( come quelle scritte da memcacheWrite() ) lo deserializza; gli altri valori vengono restituiti così come
     * sono. Il codice di risultato di Memcached viene scritto in $err: vale Memcached::RES_SUCCESS se la lettura è riuscita,
     * Memcached::RES_NOTFOUND se la chiave non esiste, Memcached::RES_FAILURE se la connessione non è valida.
     *
     * In caso di errore o di chiave assente la funzione restituisce false; siccome anche un false scritto in cache viene letto
     * come false, per distinguere i due casi si guarda $err ( fileCachedExists() per questo motivo scrive -1 al posto di false ).
     *
     * https://www.php.net/manual/en/memcached.getresultcode.php
     *
     * @param       object      $conn   la connessione a Memcached
     * @param       string      $key    la chiave da leggere, senza il seme
     * @param       int         $err    il codice di risultato di Memcached, modificato sul posto
     *
     * @return      mixed               il dato letto, oppure false se la chiave non esiste o in caso di errore
     *
     */
    function memcacheRead($conn, $key, &$err = array())
    {

        memcacheUniqueKey($key);

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
     * FUNZIONI PER I FILE IN CACHE
     */

    /**
     * verifica se un file esiste, usando la cache
     *
     * Questa funzione verifica se un file esiste con fileExists() e memorizza il risultato in cache, con la chiave
     * FILE_CACHED_EXISTS_ seguita dall'hash md5 del percorso, in modo da non ripetere la verifica a ogni richiesta; serve
     * soprattutto per i file remoti, per cui fileExists() fa una chiamata HTTP, e per le versioni minificate di CSS e JS che
     * _src/_api/_pages.php cerca a ogni pagina. Se la connessione è vuota la verifica viene fatta direttamente, senza cache.
     * Il risultato negativo viene memorizzato come -1 e restituito come false.
     *
     * TODO questa funzione andrebbe resa generalista e salvata in una libreria tipo cache utils in modo da usare
     * fra le varie cache possiili quella attiva
     *
     * @param       object      $m      la connessione a Memcached, o un valore vuoto per non usare la cache
     * @param       string      $f      il percorso o l'URL del file
     * @param       int         $t      il tempo di vita del risultato in cache in secondi ( default MEMCACHE_DEFAULT_TTL )
     * @param       int         $err    il codice di risultato della lettura dalla cache, modificato sul posto
     *
     * @return      bool                true se il file esiste, false altrimenti
     *
     */
    function fileCachedExists($m, $f, $t = MEMCACHE_DEFAULT_TTL, &$err = array())
    {

        if (! empty($m)) {

            if (empty($err)) {
                $err = Memcached::RES_FAILURE;
            }

            $k = 'FILE_CACHED_EXISTS_' . md5($f);

            $r = memcacheRead($m, $k, $err);

            if ($r === false) {
                $r = fileExists($f);
                if ($r === false) {
                    // il sentinella -1 distingue "il file non esiste" da un miss di
                    // memcache, che memcacheRead segnala anch'esso con false. Va scritto
                    // in cache ma NON restituito: -1 e' truthy, e restituirlo faceva
                    // credere al chiamante che il file esistesse. Effetto pratico: la
                    // prima richiesta dopo ogni flush emetteva URL .min.js e .min.css di
                    // file inesistenti, con script 404 in pagina (fix 2026-08-30)
                    memcacheWrite($m, $k, -1, $t);
                } else {
                    memcacheWrite($m, $k, $r, $t);
                }
            } elseif ($r === -1) {
                $r = false;
            }
        } else {

            $r = fileExists($f);
        }

        return $r;
    }

    /**
     * legge il contenuto di un file, usando la cache
     *
     * Questa funzione legge il contenuto di un file con file_get_contents() e lo memorizza in cache, con la chiave data
     * dall'hash md5 del percorso, in modo che le letture successive vengano servite dalla cache; se la connessione è vuota il
     * file viene letto direttamente. Un contenuto vuoto non viene considerato un dato valido, quindi un file vuoto viene riletto
     * ogni volta; se il file non esiste file_get_contents() restituisce false con un warning, e il false viene scritto in cache.
     *
     * TODO questa funzione andrebbe resa generalista e salvata in una libreria tipo cache utils in modo da usare
     * fra le varie cache possiili quella attiva
     *
     * @param       object      $m      la connessione a Memcached, o un valore vuoto per non usare la cache
     * @param       string      $f      il percorso o l'URL del file
     * @param       int         $t      il tempo di vita del contenuto in cache in secondi ( default MEMCACHE_DEFAULT_TTL )
     * @param       int         $err    il codice di risultato della lettura dalla cache, modificato sul posto
     *
     * @return      mixed               il contenuto del file, oppure false se non è leggibile
     *
     */
    function fileGetCachedContents($m, $f, $t = MEMCACHE_DEFAULT_TTL, &$err = array())
    {

        if (! empty($m)) {

            if (empty($err)) {
                $err = Memcached::RES_FAILURE;
            }

            $k = md5($f);

            $r = memcacheRead($m, $k, $err);

            if (empty($r) || $r === false) {
                $r = file_get_contents($f);
                memcacheWrite($m, $k, $r, $t);
            }
        } else {

            $r = file_get_contents($f);
        }

        return $r;
    }
