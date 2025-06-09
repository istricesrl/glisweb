<?php

    /**
     * questo file contiene funzioni per l'utilizzo di redis
     *
     *
     * vedi https://www.freecodecamp.org/news/how-to-use-redis-with-php/
     * vedi https://www.webarea.it/howto/nosql/redis-php-installazione-configurazione-esempi-utilizzo_160
     *
     * TODO documentare
     *
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


