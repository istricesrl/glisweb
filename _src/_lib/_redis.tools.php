<?php

    /**
     * questo file contiene funzioni per l'utilizzo di Redis
     *
     * Questa libreria è un wrapper per le funzioni di Redis, che permette di utilizzare questa cache in modo coerente alle altre cache
     * supportate dal framework. In questo modo utilizzare una cache piuttosto che un'altra è abbastanza semplice una volta capita
     * la logica generale con cui sono strutturate le librerie di caching del framework.
     *
     * introduzione
     * ============
     * Redis è un tipo di cache molto veloce, che consente di stoccare in maniera strutturata diversi tipi di oggetti; attualmente
     * GlisWeb sfrutta in maniera marginale questa caratteristica di Redis ma è pravisto di lavorarci su in futuro. Per ulteriori informazioni
     * su Redis si veda https://github.com/phpredis/phpredis/ e https://www.html.it/guide/redis-la-guida/.
     *
     * vedi anche https://www.freecodecamp.org/news/how-to-use-redis-with-php/
     * vedi anche https://www.webarea.it/howto/nosql/redis-php-installazione-configurazione-esempi-utilizzo_160
     * vedi anche https://redis.io/docs/latest/develop/clients/php/
     *
     * NOTA la connessione che il framework passa a queste funzioni ($cf['redis']['connection']) è un oggetto
     * Predis\Client, creato in _src/_config/_045.cache.php, e non un oggetto dell'estensione phpredis; i valori restituiti
     * dalle funzioni di scrittura e cancellazione sono quindi quelli di Predis (ad esempio un oggetto di stato per set()),
     * e in caso di errore del server Predis lancia un'eccezione invece di restituire false. I dati scritti devono essere
     * stringhe: la libreria non li serializza.
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti; utilizza quelle elencate nella sezione dipendenze, definite dai runlevel
     * della cache.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in tre gruppi, le funzioni di utilità generale, quelle per la scrittura e quelle per
     * la lettura.
     *
     * funzioni di utilità generale
     * ----------------------------
     * Queste funzioni consentono di semplificare alcune operazioni generali necessarie per il modo in cui il framework utilizza la
     * cache Redis.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * redisUniqueKey()                 | aggiunge il seme univoco del sito all'inizio di una chiave
     * redisAddKeyAgeSuffix()           | aggiunge il suffisso _AGE a una chiave
     * redisGetKeyAge()                 | legge il momento di scrittura di una chiave in cache
     * 
     * funzioni per la scrittura dei dati
     * ----------------------------------
     * Queste funzioni riguardano specificamente le operazioni di scrittura e cancellazione dei dati in cache.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * redisWrite()                     | scrive un dato in cache
     * redisDelete()                    | cancella un dato dalla cache
     * redisFlush()                     | cancella tutti i dati dalla cache
     *
     * funzioni per la lettura dei dati
     * --------------------------------
     * Queste funzioni riguardano la lettura dei dati in cache.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * redisRead()                      | legge un dato dalla cache
     * 
     * dipendenze
     * ==========
     * Questa libreria richiede alcune costanti che possono essere utilizzate per configurare il comportamento della cache Redis.
     * In particolare sono richieste le seguenti:
     * 
     * costante                 | spiegazione
     * -------------------------|--------------------------------------------------------------
     * REDIS_UNIQUE_SEED        | un seme univoco per la chiave, che permette di evitare collisioni fra siti diversi
     * REDIS_DEFAULT_TTL        | il tempo di vita di default di una chiave in cache, in secondi
     * 
     * REDIS_UNIQUE_SEED è definita in _src/_config/_040.cache.php a partire dall'FQDN del sito; REDIS_DEFAULT_TTL è definita
     * in _src/_config/_045.cache.php (default 3600 secondi) ma soltanto se la classe Predis\Client è disponibile.
     * 
     * Sono inoltre richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logWrite()                       | _src/_lib/_log.utils.php
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2025-06-09       | Fabio Mosti          | refactoring completo della libreria
     * 2026-09-24       | Fabio Mosti          | documentazione
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    /**
     * FUNZIONI DI UTILITÀ GENERALE
     */

    /**
     * aggiunge il seme univoco del sito all'inizio di una chiave
     * 
     * Questa funzione antepone REDIS_UNIQUE_SEED alla chiave, in modo che siti diversi che condividono lo stesso server
     * Redis non scrivano sulle stesse chiavi; se il seme è già contenuto nella chiave (in qualsiasi posizione, non
     * necessariamente all'inizio) la chiave non viene modificata, per cui la funzione può essere chiamata più volte
     * sulla stessa chiave senza effetti.
     * 
     * @param       string      $k      la chiave, modificata per riferimento
     * 
     * @return      string              la chiave con il seme univoco
     * 
     */
    function redisUniqueKey( &$k ) {

        if( strpos( $k, REDIS_UNIQUE_SEED ) === false ) {
            $k = REDIS_UNIQUE_SEED . $k;
        }

        return $k;

    }

    /**
     * aggiunge il suffisso _AGE a una chiave
     * 
     * Questa funzione restituisce il nome della chiave che memorizza il momento di scrittura della chiave data, cioè
     * la chiave stessa con il suffisso _AGE; se il suffisso è già presente la chiave viene restituita invariata.
     * 
     * @param       string      $k      la chiave
     * 
     * @return      string              la chiave con il suffisso _AGE
     * 
     */
    function redisAddKeyAgeSuffix( $k ) {

        if( substr( $k, -4 ) != '_AGE' ) {
            $k .= '_AGE';
        }

        return $k;

    }

    /**
     * legge il momento di scrittura di una chiave in cache
     * 
     * Questa funzione legge con redisRead() la chiave _AGE che redisWrite() scrive accanto a ogni chiave, e che contiene
     * la timestamp della scrittura; nonostante il nome non restituisce quindi un'età in secondi ma una timestamp. Se la
     * chiave non esiste, è scaduta o manca la connessione restituisce un valore vuoto (NULL o false).
     * 
     * @param       object      $conn       la connessione a Redis
     * @param       string      $key        la chiave di cui leggere il momento di scrittura
     * 
     * @return      mixed                   la timestamp di scrittura della chiave, oppure un valore vuoto
     * 
     */
    function redisGetKeyAge( $conn, $key ) {

        return redisRead( $conn, redisAddKeyAgeSuffix( $key ) );

    }

    /**
     * FUNZIONI PER LA SCRITTURA DEI DATI
     */

    /**
     * scrive un dato in cache
     * 
     * Questa funzione aggiunge il seme univoco alla chiave, scrive il dato e gli assegna la durata $ttl; se la scrittura
     * riesce scrive anche la chiave _AGE con la timestamp corrente e la stessa durata. Se la connessione è vuota scrive
     * nel log redis e restituisce false.
     * 
     * NOTA con Predis set() restituisce un oggetto di stato e non false, per cui il ramo di errore non viene mai
     * eseguito; in caso di errore del server Predis lancia un'eccezione. Il dato deve essere una stringa.
     * 
     * @param       object      $conn       la connessione a Redis
     * @param       string      $key        la chiave (senza seme univoco)
     * @param       string      $data       il dato da scrivere
     * @param       int         $ttl        la durata della chiave in secondi (default REDIS_DEFAULT_TTL)
     * 
     * @return      mixed                   il risultato della scrittura della chiave _AGE, false se manca la connessione
     * 
     */
    function redisWrite( $conn, $key, $data, $ttl = REDIS_DEFAULT_TTL ) {

        redisUniqueKey( $key );

        if( empty( $conn ) ) {

            logWrite( 'connessione al server assente per scrivere la chiave: ' . $key, 'redis' );

            return false;

        } else {

            $r = $conn->set( $key, $data );
            $conn->expire( $key, $ttl );

            if( $r == false ) {
                logWrite( 'impossibile scrivere la chiave: ' . $key, 'redis', LOG_ERR );
            } else {
                $r = $conn->set( redisAddKeyAgeSuffix( $key ), time() );
                $conn->expire( redisAddKeyAgeSuffix( $key ), $ttl );
                logWrite( 'scrittura effettuata, chiave: ' . redisAddKeyAgeSuffix( $key ), 'redis' );
            }

            return $r;

        }

    }

    /**
     * cancella un dato dalla cache
     * 
     * Questa funzione aggiunge il seme univoco alla chiave e la cancella; la chiave _AGE corrispondente non viene
     * cancellata e scade da sola. Se la connessione è vuota restituisce false.
     * 
     * @param       object      $conn       la connessione a Redis
     * @param       string      $key        la chiave da cancellare (senza seme univoco)
     * 
     * @return      mixed                   il numero di chiavi cancellate, false se manca la connessione
     * 
     */
    function redisDelete( $conn, $key ) {

        redisUniqueKey( $key );

        if( ! empty( $conn ) ) {
            return $conn->del( $key );
        } else {
            return false;
        }

    }

    /**
     * cancella tutti i dati dalla cache
     * 
     * Questa funzione cancella dalla cache tutte le chiavi del sito corrente, cioè quelle che cominciano con
     * REDIS_UNIQUE_SEED ( vedi redisUniqueKey() ), comprese le rispettive chiavi _AGE; le chiavi degli altri siti che
     * condividono lo stesso server non vengono toccate. Le chiavi vengono cercate con SCAN, a blocchi, e non con KEYS,
     * che su un server con molte chiavi lo bloccherebbe fino alla fine della ricerca.
     * 
     * La funzione restituisce false se la connessione non è valida, se REDIS_UNIQUE_SEED non è definita o è vuota, o se
     * il server solleva un'eccezione; altrimenti restituisce true, anche se non c'erano chiavi da cancellare.
     * 
     * NB: fino al 2026-09-24 la funzione eseguiva FLUSHALL, che cancella tutte le chiavi di tutti i database del server,
     * comprese quelle degli altri deploy; FLUSHDB non sarebbe bastato, perché _src/_config/_045.cache.php non sceglie un
     * database e tutti i deploy scrivono nel database 0. Si è seguito lo schema di memcacheFlush(), che cancella solo le
     * chiavi col seme del sito. Una chiave che contiene il seme ma non all'inizio ( redisUniqueKey() in quel caso non lo
     * antepone ) non viene cancellata; viceversa, poiché il seme è solo il FQDN, un sito il cui seme è l'inizio di quello
     * di un altro ( EXAMPLE_COM_ e EXAMPLE_COM_IT_ ) cancella anche le chiavi dell'altro.
     * 
     * @param       object      $conn       la connessione a Redis
     * 
     * @return      bool                    true se le chiavi del sito sono state cancellate, false altrimenti
     * 
     */
    function redisFlush( $conn ) {

        // validazione connessione
        if( ! is_object( $conn ) ) {
            logWrite( 'connessione al server assente o non valida per il flush', 'redis', LOG_ERR );
            return false;
        }

        // seed obbligatorio, altrimenti il filtro sulle chiavi prenderebbe tutto il server
        if( ! defined( 'REDIS_UNIQUE_SEED' ) || trim( (string) REDIS_UNIQUE_SEED ) === '' ) {
            logWrite( 'REDIS_UNIQUE_SEED non definito o vuoto', 'redis', LOG_ERR );
            return false;
        }

        // cancello a blocchi le chiavi del sito corrente
        try {

            $cursor = 0;
            $count = 0;

            do {

                list( $cursor, $keys ) = $conn->scan( $cursor, array( 'MATCH' => REDIS_UNIQUE_SEED . '*', 'COUNT' => 1000 ) );

                if( ! empty( $keys ) ) {
                    $count += $conn->del( $keys );
                }

            } while( $cursor != 0 );

        } catch( \Throwable $e ) {
            logWrite( 'eccezione nel flush: ' . $e->getMessage(), 'redis', LOG_ERR );
            return false;
        }

        // log
        logWrite( 'flush delle chiavi ' . REDIS_UNIQUE_SEED . '*: ' . $count . ' chiavi cancellate', 'redis', LOG_INFO );

        return true;

    }

    /**
     * FUNZIONI PER LA LETTURA DEI DATI
     */

    /**
     * legge un dato dalla cache
     * 
     * Questa funzione aggiunge il seme univoco alla chiave e ne legge il valore, scrivendo nel log redis l'esito della
     * lettura. Se la connessione è vuota restituisce false; se la chiave non esiste o è scaduta restituisce quello che
     * restituisce il client (NULL con Predis). Un valore vuoto o '0' viene letto correttamente ma registrato nel log
     * come lettura fallita.
     * 
     * @param       object      $conn       la connessione a Redis
     * @param       string      $key        la chiave da leggere (senza seme univoco)
     * 
     * @return      mixed                   il valore letto, un valore vuoto se la chiave non esiste, false se manca la
     *                                      connessione
     * 
     */
    function redisRead( $conn, $key ) {

        redisUniqueKey( $key );

        if( empty( $conn ) ) {

            logWrite( 'connessione al server assente per leggere la chiave: ' . $key, 'redis' );

            return false;

        } else {

            $r = $conn->get( $key );

            if( $r == false ) {
                logWrite( 'impossibile leggere la chiave: ' . $key, 'redis' );
            } else {
                logWrite( 'lettura effettuata, chiave: ' . $key, 'redis' );
            }

            return $r;

        }

    }
