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
                $r = $conn->set( memcacheAddKeyAgeSuffix( $key ), time(), $ttl );
                logger( 'scrittura effettuata, chiave: ' . memcacheAddKeyAgeSuffix( $key ), 'memcache' );
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
    function memcacheFlush( $conn ) {

        if( empty( $conn ) ) {

        logWrite( 'connessione al server assente per eliminare la chiave: ' . $key, 'memcache' );

        return false;

        } elseif( ! is_object( $conn ) ) {

            logWrite( 'connessione al server assente per eliminare la chiave: ' . $key, 'memcache' );

            return false;

        } else {

            return $conn->flush();

        }

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

    if( empty( $conn ) ) {

        logger( 'connessione al server assente per leggere la chiave: ' . $key, 'memcache' );

        return false;

        } elseif( ! is_object( $conn ) ) {

        logger( 'connessione al server assente per leggere la chiave: ' . $key, 'memcache' );

        return false;

    } else {

        if( empty( $err ) ) {
            $err = Memcached::RES_FAILURE;
        }

        $r = $conn->get( $key );

        $err = $conn->getResultCode();

        if( $r === false ) {
            logger( 'impossibile (' . $conn->getResultCode() . ') leggere la chiave: ' . $key, 'memcache' );
        } else {
            logger( 'lettura effettuata, chiave: ' . $key, 'memcache' );
        }

        return unserialize( $r );

    }

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

            $k = md5( $f );

            $r = memcacheRead( $m, $k, $err );

            if( $r === false ) {
                $r = fileExists( $f );
                memcacheWrite( $m, $k, $r, $t );
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
