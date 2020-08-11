<?php

    /**
     * file di configurazione delle cache
     *
     * sistemi di cache
     * ================
     * Il framework supporta Memcache e Redis, oltre ad alcune cache su disco per velocizzare la rappresentazione
     * dei contenuti.
     *
     * Memcache
     * --------
     *
     *
     *
     *
     *
     * Redis
     * -----
     *
     *
     *
     *
     *
     * @todo perché non c'è la chiave univoca per Redis?
     * @todo finire di documentare
     *
     * @file
     *
     */

    // stringa di unicità per sito
	define( 'MEMCACHE_UNIQUE_SEED'		, strtoupper( str_replace( '.', '_', $cf['site']['fqdn'] ) . '_' ) );

    // costanti per i blocchi di dati da salvare in cache
	define( 'CONTENTS_PAGES_DATA'		, 'CONTENTS_PAGES_DATA' );
	define( 'CONTENTS_PAGES_UPDATED'	, 'CONTENTS_PAGES_UPDATED' );
	define( 'CONTENTS_INDEX_KEY'		, 'CONTENTS_INDEX_KEY' );
	define( 'CONTENTS_TREE_KEY'		, 'CONTENTS_TREE_KEY' );
	define( 'CONTENTS_PAGES_KEY'		, 'CONTENTS_PAGES_KEY' );
	define( 'CONTENTS_SHORTCUTS_KEY'	, 'SHORTCUTS_PAGES_KEY' );

    // server memcache disponibili
	$cf['memcache']['servers']			= array();

    // profili di funzionamento del sistema memcache
	$cf['memcache']['profiles'][ DEVELOPEMENT ]	=
	$cf['memcache']['profiles'][ TESTING ]		=
	$cf['memcache']['profiles'][ PRODUCTION ]	= array();

    // link al profilo corrente
	$cf['memcache']['profile']			= &$cf['memcache']['profiles'][ $cf['site']['status'] ];

    // connessioni disponibili
	$cf['memcache']['connections']			= array();

    // link alla connessione corrente
	$cf['memcache']['connection']			= NULL;

    // TTL di default
	$cf['memcache']['ttl']				= 0;

    // configurazione extra
	if( isset( $cx['memcache'] ) ) {
	    $cf['memcache'] = array_replace_recursive( $cf['memcache'], $cx['memcache'] );
	}

    // server redis disponibili
	$cf['redis']['servers']				= array();

    // profili di funzionamento del sistema redis
	$cf['redis']['profiles'][ DEVELOPEMENT ]	=
	$cf['redis']['profiles'][ TESTING ]		=
	$cf['redis']['profiles'][ PRODUCTION ]		= array();

    // link al profilo corrente
	$cf['redis']['profile']				= &$cf['redis']['profiles'][ $cf['site']['status'] ];

    // connessioni disponibili
	$cf['redis']['connections']			= array();

    // link alla connessione corrente
	$cf['redis']['connection']			= NULL;

    // TTL di default
	$cf['redis']['ttl']				= 0;

    // configurazione extra
	if( isset( $cx['redis'] ) ) {
	    $cf['redis'] = array_replace_recursive( $cf['redis'], $cx['redis'] );
	}

    // debug
	// print_r( $cf['redis'] );

?>
