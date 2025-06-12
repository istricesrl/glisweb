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
     * redisUniqueKey()                 | aggiunge un seme univoco alla chiave, per evitare collisioni fra siti diversi
     * redisAddKeyAgeSuffix()           | aggiunge il suffisso _AGE alla chiave, per memorizzare l'età della chiave
     * redisGetKeyAge()                 | legge l'età di una chiave in cache
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
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2025-06-09       | Fabio Mosti          | refactoring completo della libreria
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
     * 
     * 
     * 
     * TODO documentare
     * 
     */
    function redisUniqueKey( &$k ) {

        if( strpos( $k, REDIS_UNIQUE_SEED ) === false ) {
            $k = REDIS_UNIQUE_SEED . $k;
        }

        return $k;

    }

    /**
     * 
     * 
     * 
     * TODO documentare
     * 
     */
    function redisAddKeyAgeSuffix( $k ) {

        if( substr( $k, -4 ) != '_AGE' ) {
            $k .= '_AGE';
        }

        return $k;

    }

    /**
     * 
     * 
     * TODO documentare
     * 
     */
    function redisGetKeyAge( $conn, $key ) {

        return redisRead( $conn, redisAddKeyAgeSuffix( $key ) );

    }

    /**
     * FUNZIONI PER LA SCRITTURA DEI DATI
     */

    /**
     * 
     * 
     * 
     * TODO documentare
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
     * 
     * 
     * 
     * TODO documentare
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
     * 
     * 
     * 
     * TODO documentare
     * 
     */
    function redisFlush( $conn ) {

	    return $conn->flushall();

    }

    /**
     * FUNZIONI PER LA LETTURA DEI DATI
     */

    /**
     * 
     * 
     * 
     * TODO documentare
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
