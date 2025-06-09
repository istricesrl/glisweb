<?php

    /**
     * questo file contiene funzioni per l'utilizzo di memcache
     *
     *
     *
     *
     *
     * TODO documentare
     *
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
    function memcacheGetKeyAge( $conn, $key ) {

        return memcacheRead( $conn, memcacheAddKeyAgeSuffix( $key ) );

    }

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
