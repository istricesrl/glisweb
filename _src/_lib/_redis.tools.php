<?php

    /**
     * questo file contiene funzioni per l'utilizzo di redis
     *
     *
     *
     *
     *
     * @file
     *
     */

/*     
    function redisUniqueKey( &$k ) {

	if( strpos( $k, REDIS_UNIQUE_SEED ) === false ) {
	    $k = REDIS_UNIQUE_SEED . $k;
	}

	return $k;

    }

    function redisAddKeyAgeSuffix( $k ) {

        if( substr( $k, -4 ) != '_AGE' ) {
            $k .= '_AGE';
        }

        return $k;

    }

    function redisWrite( $conn, $key, $data, $ttl = REDIS_DEFAULT_TTL ) {

        redisUniqueKey( $key );

        if( empty( $conn ) ) {

            logWrite( 'connessione al server assente per scrivere la chiave: ' . $key, 'redis' );

            return false;

        } else {

            $conn->setOption( Memcached::OPT_COMPRESSION, true );

            $r = $conn->set( $key, $data, $ttl );

            if( $r == false ) {
                logWrite( 'impossibile (' . $conn->getResultCode() . ') scrivere la chiave: ' . $key, 'redis', LOG_ERR );
            } else {
                $r = $conn->set( redisAddKeyAgeSuffix( $key ), time(), $ttl );
                logWrite( 'scrittura effettuata, chiave: ' . redisAddKeyAgeSuffix( $key ), 'redis' );
            }

            return $r;

        }

    }

    function redisGetKeyAge( $conn, $key ) {

        return redisRead( $conn, redisAddKeyAgeSuffix( $key ) );

    }

    function redisRead( $conn, $key ) {

	redisUniqueKey( $key );

	if( empty( $conn ) ) {

		logWrite( 'connessione al server assente per leggere la chiave: ' . $key, 'redis' );

		return false;

	} else {

		$r = $conn->get( $key );

		if( $r == false ) {
		    logWrite( 'impossibile (' . $conn->getResultCode() . ') leggere la chiave: ' . $key, 'redis' );
		} else {
		    logWrite( 'lettura effettuata, chiave: ' . $key, 'redis' );
		}

		return $r;

	}

    }

    function redisDelete( $conn, $key ) {

	redisUniqueKey( $key );

    if( ! empty( $conn ) ) {
        return $conn->delete( $key );
    } else {
        return false;
    }

    }

    function redisFlush( $conn ) {

	return $conn->flush();

    }

    function fileCachedExists( $m, $f, $t = REDIS_DEFAULT_TTL, &$e = array() ) {

	// calcolo la chiave della query
	    $k = md5( $f );

	// cerco il valore in cache
	    $r = redisRead( $m, $k );

	// se il valore non è stato trovato
	    if( empty( $r ) || $r === false ) {
		$r = fileExists( $f );
		redisWrite( $m, $k, serialize( $r ), $t );
	    } else {
		$r = unserialize( $r );
	    }

	// restituisco il risultato
	    return $r;

    }

    function fileGetCachedContents( $m, $f, $t = REDIS_DEFAULT_TTL, &$e = array() ) {

	// calcolo la chiave della query
	    $k = md5( $f );

	// cerco il valore in cache
	    $r = redisRead( $m, $k );

	// se il valore non è stato trovato
	    if( empty( $r ) || $r === false ) {
		$r = file_get_contents( $f );
		redisWrite( $m, $k, serialize( $r ), $t );
	    } else {
		$r = unserialize( $r );
	    }

	// restituisco il risultato
	    return $r;

    }
*/
