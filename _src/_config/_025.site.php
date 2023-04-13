<?php

    /**
     * applicazione della configurazione base del sito
     *
     * Questo file applica le configurazioni fatte finora e crea alcune chiavi "brevi" per le variabili di uso comune.
     *
     * configurazione del sito
     * =======================
     * Lo scopo di questo file è ricavare dalla configurazione del sito i dati e le informazioni che vengono utilizzati
     * più spesso in modo da facilitarne il reperimento nell'output space. Per un esame dettagliato delle chiavi e dei
     * sotto array di $cf['site'] si veda il \ref variabili "capitolo dedicato alle variabili della documentazione
     * tecnica".
     *
     * scorciatoie dell'array $cf['site']
     * ----------------------------------
     * Riportiamo qui di seguito le scorciatoie create nell'array $cf['site']; si tratta solo di chiavi pensate per
     * l'accesso rapido alle informazioni e non contengono dati originali:
     *
     * variabile               | scorciatoia per...
     * ------------------------|----------------------------------------------------------------
     * $cf['site']['domain']   | $cf['site']['domains'][ $cf['site']['status'] ]
     * $cf['site']['fqdn']     | $cf['site']['host'].'.'.$cf['site']['domain']
     * $cf['site']['home']     | $cf['site']['homes'][ $cf['site']['status'] ]
     * $cf['site']['host']     | $cf['site']['hosts'][ $cf['site']['status'] ]
     * $cf['site']['ietf']     | $cf['localization']['language']['ietf']
     * $cf['site']['root']     | '/' . $cf['site']['folders'][ $cf['site']['status'] ]
     * $cf['site']['url']      | $cf['site']['urls'][ $cf['site']['status'] ]
     *
     * Si noti che $cf['site']['ietf'] viene dichiarata successivamente in _src/_config/_070.localization.php
     *
     *
     *
     *
     *
     *
     * @todo creare una scorciatoia anche per $cf['localization']['language']['ietf'] tipo $cf['site']['ietf']
     * @todo documentare $cf['site']['url'] e $cf['site']['root']
     *
     * @file
     *
     */

    // carattere di default per la separazione delle parole negli URL
	if( ! defined( 'URL_WORD_SEPARATOR' ) ) {
	    define( 'URL_WORD_SEPARATOR'		, '-' );
	}

    // carattere di default per separare il titolo del sito da quello della pagina nel tag <title>
	if( ! defined( 'TITLE_SEPARATOR' ) ) {
	    define( 'TITLE_SEPARATOR'		    , ' | ' );
	}

    // gli URL del sito
	foreach( array_keys( $cf['site']['domains'] ) as $status ) {

	    $cf['site']['urls'][ $status ] =
		$cf['site']['protocols'][ $status ] . '://' .
		(
		    ( ! empty( $cf['site']['hosts'][ $status ] ) )
		    ? $cf['site']['hosts'][ $status ] . ( ( ! empty( $cf['site']['domains'][ $status ] ) ) ? '.' : NULL )
		    : NULL 
		).
		$cf['site']['domains'][ $status ] . '/' .
		( ( isset( $cf['site']['folders'][ $cf['site']['status'] ] ) ) ? $cf['site']['folders'][ $cf['site']['status'] ] : NULL );

	}

    // URL corrente del sito
	$cf['site']['home']			= &$cf['site']['homes'][ $cf['site']['status'] ];

    // URL corrente del sito
	$cf['site']['url']			= &$cf['site']['urls'][ $cf['site']['status'] ];

    // dominio corrente del sito
	$cf['site']['domain']			= &$cf['site']['domains'][ $cf['site']['status'] ];

    // host corrente del sito
	$cf['site']['host']			= &$cf['site']['hosts'][ $cf['site']['status'] ];

    // FQDN corrente del sito
	$cf['site']['fqdn']			= trim( $cf['site']['host'] . ( ( ! empty( $cf['site']['domain'] ) ) ? '.' . $cf['site']['domain'] : NULL ), ". \t\n\r\0\x0B" );

    // percorso della cartella root del sito
	$cf['site']['root']			= '/' . ( ( isset( $cf['site']['folders'][ $cf['site']['status'] ] ) ) ? $cf['site']['folders'][ $cf['site']['status'] ] : NULL );

    // pulisco la variabile REDIRECT_URL per far corrispondere la cartella base alla pagina home
	if( isset( $_SERVER['REDIRECT_URL'] ) ) {
	    $_SERVER['REDIRECT_URL']		= substr( $_SERVER['REDIRECT_URL'], strlen( $cf['site']['root'] ) );
	}

    // configurazione extra
	if( isset( $cx['site'] ) ) {
	    $cf['site'] = array_replace_recursive( $cf['site'], $cx['site'] );
	}

    // collegamento dell'array $ct
	$ct['site']				= &$cf['site'];

    // debug
	// dieText( print_r( $cf['site'], true ) );
