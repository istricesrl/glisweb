<?php

    /**
     * applicazione della configurazione delle cache
     *
     *
     *
     * @todo confrontare la struttura di questo file con _125.mysql.php
     * @todo perché Redis non ha la costante per il default TTL?
     * @todo aggiungere la verifica della connessione a memcache
     * @todo documentare
     *
     * @file
     *
     */

    // link alla connessione corrente
	$cf['memcache']['connection']			= NULL;

    // link al profilo corrente
	$cf['memcache']['profile']			= &$cf['memcache']['profiles'][ $cf['site']['status'] ];

    // ciclo sui server disponibili
	if( isset( $cf['memcache']['profile']['servers'] ) && is_array( $cf['memcache']['profile']['servers'] ) ) {

	    // ciclo sui server del profilo corrente
		foreach( $cf['memcache']['profile']['servers'] as $server ) {

		    // inizializzazione
			$cn = new Memcached();

		    // connessione
			$cn->addServer(
			    $cf['memcache']['servers'][ $server ]['address'],
			    $cf['memcache']['servers'][ $server ]['port']
			);

		    // registro la connessione
			if( ! empty( $cn ) ) {
			    $stats = $cn->getStats();
			    $cf['memcache']['connections'][ $server ] = $cn;
			    $cf['memcache']['stats'][ $server ] = array_shift( $stats );
			    logWrite( 'connessione effettuata al server ' . $server, 'memcache' );
			} else {
			    logWrite( 'impossibile (' . $cn->getResultCode() . ') connettersi a ' . $server, 'memcache', LOG_ERR );
			}

		}

	    // connessione di default
		if( count( $cf['memcache']['connections'] ) ) {
		    $keys = array_keys( $cf['memcache']['connections'] );
		    $key = array_shift( $keys );
		    $cf['memcache']['connection'] = &$cf['memcache']['connections'][ $key ];
		    $cf['memcache']['server'] = &$cf['memcache']['servers'][ $key ];
		    $cf['memcache']['stat'] = &$cf['memcache']['stats'][ $key ];
		    $cf['memcache']['stat']['usage'] = writeByte( $cf['memcache']['stat']['bytes'] ) . ' su ' . writeByte( $cf['memcache']['stat']['limit_maxbytes'] );
		    $cf['memcache']['stat']['percent'] = sprintf( '%01.2f', $cf['memcache']['stat']['bytes'] * 100 / $cf['memcache']['stat']['limit_maxbytes'] ) . '%';
		    $cf['memcache']['stat']['hits'] = 'trovati ' . $cf['memcache']['stat']['get_hits'] . ' oggetti contro ' . $cf['memcache']['stat']['get_misses'] . ' non trovati';
		    if( isset( $cf['memcache']['stat']['get_hits'] ) && ! empty( $cf['memcache']['stat']['get_hits'] ) && isset( $cf['memcache']['stat']['get_misses'] ) ) {
			$cf['memcache']['stat']['hitrate'] = sprintf( '%01.2f', $cf['memcache']['stat']['get_hits'] * 100 / ( $cf['memcache']['stat']['get_hits'] + $cf['memcache']['stat']['get_misses'] ) ) . '%';
		    }
		}

	} else {

	    // log
		logWrite( 'nessun profilo memcache impostato per il livello di funzionamento corrente', 'memcache' );

	}

    // costante per il default TTL
	define( 'MEMCACHE_DEFAULT_TTL'		, ( ( isset( $cf['memcache']['server']['ttl'] ) ) ? $cf['memcache']['server']['ttl'] : 0 ) );

    // link alla connessione corrente
	$cf['redis']['connection']			= NULL;

    // link al profilo corrente
	$cf['redis']['profile'] = &$cf['redis']['profiles'][ $cf['site']['status'] ];

    // ciclo sui server disponibili
	if( isset( $cf['redis']['profile']['servers'] ) && is_array( $cf['redis']['profile']['servers'] ) ) {

	    // ciclo sui server del profilo corrente
		foreach( $cf['redis']['profile']['servers'] as $server ) {

		    // connessione
			$cn = new Predis\Client([
			    'scheme' => 'tcp',
			    'host'   => $cf['redis']['servers'][ $server ]['address'],
			    'port'   => $cf['redis']['servers'][ $server ]['port']
			]);

		    // registro la connessione
			if( ! empty( $cn ) ) {
			    $cf['redis']['connections'][ $server ] = $cn;
			    logWrite( 'connessione effettuata al server ' . $server, 'redis' );
			} else {
			    logWrite( 'impossibile connettersi al server ' . $server, 'redis', LOG_ERR );
			}

		}

	    // connessione di default
		if( count( $cf['redis']['connections'] ) ) {
		    $keys = array_keys( $cf['redis']['connections'] );
		    $key = array_shift( $keys );
		    $cf['redis']['connection'] = &$cf['redis']['connections'][ $key ];
		    $cf['redis']['server'] = &$cf['redis']['servers'][ $key ];
		}

	} else {

	    // log
		logWrite( 'nessun profilo redis impostato per il livello di funzionamento corrente', 'redis' );

	}

    // costante per il default TTL
	define( 'REDIS_DEFAULT_TTL'			, ( ( isset( $cf['redis']['server']['ttl'] ) ) ? $cf['redis']['server']['ttl'] : 0 ) );

    // lettura indici della cache
	$cf['memcache']['index'] = memcacheRead( $cf['memcache']['connection'], 'CACHE_INDEX' );

    // inizializzazione indice della cache
	if( empty( $cf['memcache']['index'] ) ){
	    $cf['memcache']['index'] = array();
	}

/*
    // inizializzazione regustro della cache
	if( empty( $cf['memcache']['registry'] ) ){
	    $cf['memcache']['registry'] = array();
	}
*/

    // debug
	// print_r( $cf['memcache']['profile'] );
	// print_r( $cf['memcache']['profiles'] );
	// echo $cf['site']['status'] . PHP_EOL;
	// var_dump( $cf['memcache'] );
