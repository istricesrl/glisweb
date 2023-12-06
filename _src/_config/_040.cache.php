<?php

    /**
     * file di configurazione delle cache
     *
     * il sistema dei profili
     * ======================
     * In questo file incontriamo per la prima volta il sistema dei profili in tutta la sua completezza. In generale il
     * framework adotta questo approccio ogni volta che le informazioni relative a determinati servizi cambiano a seconda
     * dello status (DEV/TEST/PROD) in cui si trova il deploy. Noterete che lo schema si ripete invariato per servizi
     * relativamente semplici (come la cache) fino a quelli più complessi come i database. Lo schema prevede sempre la
     * stessa sequenza di passi, anche se alcuni possono essere assenti in determinati contesti; la sequenza nel primo file è:
     *
     * -# dichiarazione dei server disponibili ($cf[<servizio>]['servers'])
     * -# dichiarazione dei profili per ogni status ($cf[<servizio>]['profiles'][<status>][...])
     * -# inizializzazione dell'array delle connessioni ($cf[<servizio>]['connections'])
     * -# applicazione della configurazione extra ($cx[<servizio>] su $cf[<servizio>])
     * -# collegamento di $ct ($cf[<servizio>] collegato a $ct[<servizio>])
     *
     * Nel secondo file, quello esecutivo, la sequenza è:
     *
     * -# collegamento del profilo corrente ($cf[<servizio>]['profile'] collegato a $cf[<servizio>]['profiles'][<status>])
     * -# collegamento della connessione corrente ($cf[<servizio>]['connection'] collegato a $cf[<servizio>]['connections'][0])
     * -# collegamento del server corrente ($cf[<servizio>]['server'] collegato a $cf[<servizio>]['servers'][0])
     *
     * La rigidità e la ripetitività di questo schema
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
	define( 'MEMCACHE_UNIQUE_SEED'			, strtoupper( str_replace( '.', '_', $cf['site']['fqdn'] ) . '_' ) );

    // costanti per i blocchi di dati da salvare in cache
	define( 'CONTENTS_PAGES_DATA'			    , 'CONTENTS_PAGES_DATA' );
	define( 'CONTENTS_PAGES_UPDATED'		    , 'CONTENTS_PAGES_UPDATED' );
	define( 'CONTENTS_PAGES_CACHED'		        , 'CONTENTS_PAGES_CACHED' );
	define( 'CONTENTS_INDEX_KEY'			    , 'CONTENTS_INDEX_KEY' );
	define( 'CONTENTS_REVERSE_KEY'			    , 'CONTENTS_REVERSE_KEY' );
	define( 'CONTENTS_TREE_KEY'			        , 'CONTENTS_TREE_KEY' );
	define( 'CONTENTS_PAGES_KEY'			    , 'CONTENTS_PAGES_KEY' );
	define( 'CONTENTS_SHORTCUTS_KEY'		    , 'SHORTCUTS_PAGES_KEY' );

    // server memcache disponibili
	$cf['memcache']['servers']			        = array();

    // profili di funzionamento del sistema memcache
	$cf['memcache']['profiles'][ DEVELOPEMENT ]	=
	$cf['memcache']['profiles'][ TESTING ]		=
	$cf['memcache']['profiles'][ PRODUCTION ]	= array();

    // connessioni disponibili
	$cf['memcache']['connections']			    = array();

    // configurazione extra
	if( isset( $cx['memcache'] ) ) {
	    $cf['memcache'] = array_replace_recursive( $cf['memcache'], $cx['memcache'] );
	}

    // collegamento all'array $ct
	$ct['memcache']					            = &$cf['memcache'];

    // stringa di unicità per sito
	define( 'REDIS_UNIQUE_SEED'			    , strtoupper( str_replace( '.', '_', $cf['site']['fqdn'] ) . '_' ) );

    // server redis disponibili
	$cf['redis']['servers']				= array();

    // profili di funzionamento del sistema redis
	$cf['redis']['profiles'][ DEVELOPEMENT ]	=
	$cf['redis']['profiles'][ TESTING ]		=
	$cf['redis']['profiles'][ PRODUCTION ]		= array();

    // connessioni disponibili
	$cf['redis']['connections']			= array();

    // configurazione extra
	if( isset( $cx['redis'] ) ) {
	    $cf['redis'] = array_replace_recursive( $cf['redis'], $cx['redis'] );
	}

    // collegamento all'array $ct
	$ct['redis']					= &$cf['redis'];

    // debug
	// print_r( $cf['memcache'] );
	// print_r( $cf['redis'] );
