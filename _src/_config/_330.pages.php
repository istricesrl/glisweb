<?php

    /**
     *
     *
     *
     *
     *
     *
     * @todo documentare
     * @todo salvare in cache il rewriteIndex e il tree
     * @todo la funzione rewritePath() viene chiamata per pagine che hanno già un path!
     *
     * @file
     *
     */

    // debug
	// print_r( $cf['contents']['pages'] );

	// cache della timestamp di aggiornamento
	memcacheWrite( $cf['memcache']['connection'], CONTENTS_PAGES_UPDATED, $cf['contents']['updated'] );

    // cache delle pagine
#11	if( $cf['pages']['cacheable'] == true ) {
	if( $cf['contents']['cached'] === false ) {

	    // controllo connessione
		if( ! empty( $cf['memcache']['connection'] ) ) {

		    // scrittura della cache
			memcacheWrite( $cf['memcache']['connection'], CONTENTS_PAGES_KEY, $cf['contents']['pages'] );
			memcacheWrite( $cf['memcache']['connection'], CONTENTS_TREE_KEY, $cf['contents']['tree'] );
			memcacheWrite( $cf['memcache']['connection'], CONTENTS_INDEX_KEY, $cf['contents']['index'] );
			memcacheWrite( $cf['memcache']['connection'], CONTENTS_REVERSE_KEY, $cf['contents']['reverse'] );
			memcacheWrite( $cf['memcache']['connection'], CONTENTS_SHORTCUTS_KEY, $cf['contents']['shortcuts'] );
			memcacheWrite( $cf['memcache']['connection'], CONTENTS_PAGES_CACHED, time() );

		    // timer
			timerCheck( $cf['speed'], '-> fine scrittura cache pagine' );

#11	} else {

	    // lettura delle pagine dalla cache
#11		$cf['contents']['pages']		= memcacheRead( $cf['memcache']['connection'], CONTENTS_PAGES_KEY );
#11		$cf['contents']['updated']		= memcacheRead( $cf['memcache']['connection'], CONTENTS_PAGES_UPDATED );

		    // log
			logWrite( 'struttura delle pagine scritta in cache', 'speed', LOG_ERR );

	    // timer
#11		timerCheck( $cf['speed'], '-> fine lettura cache pagine' );

		} else {

		    // log
			logWrite( 'impossibile scrivere le pagine in cache per mancanza di connessione a memcache', 'speed' );

		}

	} else {

	    // log
		logWrite( 'pagine già presenti in cache, nessuna scrittura richiesta', 'speed' );

	}

    // debug
	// memcacheDelete( $cf['memcache']['connection'], CONTENTS_TREE_KEY );
	// memcacheDelete( $cf['memcache']['connection'], CONTENTS_INDEX_KEY );
	// memcacheDelete( $cf['memcache']['connection'], CONTENTS_PAGES_KEY );
	// print_r( memcacheRead( $cf['memcache']['connection'], CONTENTS_PAGES_KEY ) );
	// print_r( $cf['localization']['language'] );
	// print_r( $cf['contents']['index'] );
	// print_r( $cf['contents']['pages']['licenza']['content'] );
	// echo $cf['contents']['updated'];
