<?php

    /**
     * questo file contiene funzioni per l'utilizzo di memcache
     *
     *
     *
     *
     *
     * @file
     *
     */

    /**
     *
     * @todo documentare
     *
     */
    function memcacheUniqueKey( &$k ) {

	if( strpos( $k, MEMCACHE_UNIQUE_SEED ) === false ) {
	    $k = MEMCACHE_UNIQUE_SEED . $k;
	}

	return $k;

    }

    function memcacheAddKeyAgeSuffix( $k ) {

        if( substr( $k, -4 ) != '_AGE' ) {
            $k .= '_AGE';
        }

        return $k;

    }

    /**
     *
     * @todo documentare
     *
     */
    function memcacheWrite( $conn, $key, $data, $ttl = MEMCACHE_DEFAULT_TTL ) {

        memcacheUniqueKey( $key );

        if( empty( $conn ) ) {

            logWrite( 'connessione al server assente per scrivere la chiave: ' . $key, 'memcache' );

            return false;

        } else {

            $conn->setOption( Memcached::OPT_COMPRESSION, true );

            $r = $conn->set( $key, serialize( $data ), $ttl );

            if( $r === false ) {
                logWrite( 'impossibile (' . $conn->getResultCode() . ') scrivere la chiave: ' . $key, 'memcache', LOG_ERR );
            } else {
                $r = $conn->set( memcacheAddKeyAgeSuffix( $key ), time(), $ttl );
                logWrite( 'scrittura effettuata, chiave: ' . memcacheAddKeyAgeSuffix( $key ), 'memcache' );
            }

            return $r;

        }

    }

    /**
     *
     * @todo documentare
     *
     */
    function memcacheGetKeyAge( $conn, $key ) {

        return memcacheRead( $conn, memcacheAddKeyAgeSuffix( $key ) );

    }

    /**
     *
     * https://www.php.net/manual/en/memcached.getresultcode.php
     * 
     * @todo documentare
     *
     */
    function memcacheRead( $conn, $key, &$err = Memcached::RES_FAILURE ) {

	memcacheUniqueKey( $key );

	if( empty( $conn ) ) {

		logWrite( 'connessione al server assente per leggere la chiave: ' . $key, 'memcache' );

		return false;

	} else {

		$r = $conn->get( $key );

        $err = $conn->getResultCode();

		if( $r === false ) {
		    logWrite( 'impossibile (' . $conn->getResultCode() . ') leggere la chiave: ' . $key, 'memcache' );
		} else {
		    logWrite( 'lettura effettuata, chiave: ' . $key, 'memcache' );
		}

		return unserialize( $r );

	}

    }

    /**
     *
     * @todo documentare
     *
     */
    function memcacheDelete( $conn, $key, &$err = Memcached::RES_FAILURE ) {

        memcacheUniqueKey( $key );

        if( empty( $conn ) ) {

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
     * @todo documentare
     *
     */
    function memcacheFlush( $conn ) {

        if( empty( $conn ) ) {

            return false;

        } else {

	        return $conn->flush();

        }

    }

    /**
     *
     * @todo documentare
     *
     */
    function fileCachedExists( $m, $f, $t = MEMCACHE_DEFAULT_TTL, &$err = Memcached::RES_FAILURE ) {

	// calcolo la chiave della query
	    $k = md5( $f );

	// cerco il valore in cache
	    $r = memcacheRead( $m, $k, $err );

	// se il valore non è stato trovato
	    if( $r === false ) {
		$r = fileExists( $f );
		memcacheWrite( $m, $k, $r, $t );
	    }

	// restituisco il risultato
	    return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function fileGetCachedContents( $m, $f, $t = MEMCACHE_DEFAULT_TTL, &$err = Memcached::RES_FAILURE ) {

	// calcolo la chiave della query
	    $k = md5( $f );

	// cerco il valore in cache
	    $r = memcacheRead( $m, $k, $err );

	// se il valore non è stato trovato
	    if( empty( $r ) || $r === false ) {
		$r = file_get_contents( $f );
		memcacheWrite( $m, $k, $r, $t );
	    }

	// restituisco il risultato
	    return $r;

    }
