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

    /**
     *
     * @todo documentare
     *
     */
    function memcacheWrite( $conn, $key, $data, $ttl = MEMCACHE_DEFAULT_TTL, $seed = MEMCACHE_UNIQUE_SEED ) {

	memcacheUniqueKey( $key );

	if( empty( $conn ) ) {

		// TODO qui loggare

		return false;

	} else {

		$r = memcache_set( $conn, $key, $data, MEMCACHE_COMPRESSED, $ttl );

		if( $r == false ) {
		    logWrite( 'impossibile scrivere la chiave: ' . $key, 'memcache', LOG_ERR );
		} else {
		    logWrite( 'scrittura effettuata, chiave: ' . $key, 'memcache', LOG_DEBUG );
		}

		return $r;

	}

    }

    /**
     *
     * @todo documentare
     *
     */
    function memcacheRead( $conn, $key ) {

	// TODO questa logica complica il log della connessione vuota

	memcacheUniqueKey( $key );

	if( empty( $conn ) ) {

		// TODO qui loggare

		return false;

	} else {

		$r = memcache_get( $conn, $key );

		if( $r == false ) {
		    logWrite( 'impossibile leggere la chiave: ' . $key, 'memcache', LOG_DEBUG );
		} else {
		    logWrite( 'lettura effettuata, chiave: ' . $key, 'memcache', LOG_DEBUG );
		}

		return $r;

	}

    }

    /**
     *
     * @todo documentare
     *
     */
    function memcacheDelete( $conn, $key ) {

	memcacheUniqueKey( $key );

	return memcache_delete( $conn, $key );

    }

    /**
     *
    // TODO vanno bloccate le scritture per almeno un secondo dopo il flush,
    // vedi http://php.net/manual/en/memcache.flush.php
     * @todo documentare
     *
     */
    function memcacheFlush( $conn ) {

	$t = memcache_flush( $conn );

	sleep( 2 );

	return $t;

    }

    /**
     *
     * @todo documentare
     *
     */
    function fileCachedExists( $m, $f, $t = MEMCACHE_DEFAULT_TTL, &$e = array() ) {

	// calcolo la chiave della query
	    $k = md5( $f );

	// cerco il valore in cache
	    $r = memcacheRead( $m, $k );

	// se il valore non è stato trovato
	    if( empty( $r ) || $r === false ) {
		$r = fileExists( $f );
		memcacheWrite( $m, $k, serialize( $r ), $t );
	    } else {
		$r = unserialize( $r );
	    }

	// restituisco il risultato
	    return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function fileGetCachedContents( $m, $f, $t = MEMCACHE_DEFAULT_TTL, &$e = array() ) {

	// calcolo la chiave della query
	    $k = md5( $f );

	// cerco il valore in cache
	    $r = memcacheRead( $m, $k );

	// se il valore non è stato trovato
	    if( empty( $r ) || $r === false ) {
		$r = file_get_contents( $f );
		memcacheWrite( $m, $k, serialize( $r ), $t );
	    } else {
		$r = unserialize( $r );
	    }

	// restituisco il risultato
	    return $r;

    }

?>
