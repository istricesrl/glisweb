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
     * definizione di costanti del sito
     * --------------------------------
     * In questa sezione vengono definite alcune costanti necessarie al funzionamento del sito.
     * 
     * elaborazione dei dati del sito
     * ------------------------------
     * In questo file vengono elaborate le informazioni del sito per ricavare dati che derivano da quelli già presenti
     * nella configurazione. Ad esempio, vengono ricavati gli URL del sito a partire dai dati di dominio, host eccetera.
     * 
     * scorciatoie dell'array $cf['site']
     * ----------------------------------
     * Riportiamo qui di seguito le scorciatoie create nell'array $cf['site']; si tratta solo di chiavi pensate per
     * l'accesso rapido alle informazioni e non contengono dati originali:
     *
     * variabile               | scorciatoia per...
     * ------------------------|----------------------------------------------------------------
     * $cf['site']['domain']   | $cf['site']['domains'][ SITE_STATUS ]
     * $cf['site']['fqdn']     | $cf['site']['host'].'.'.$cf['site']['domain']
     * $cf['site']['home']     | $cf['site']['homes'][ SITE_STATUS ]
     * $cf['site']['host']     | $cf['site']['hosts'][ SITE_STATUS ]
     * $cf['site']['ietf']     | $cf['localization']['language']['ietf']
     * $cf['site']['root']     | '/' . $cf['site']['folders'][ SITE_STATUS ]
     * $cf['site']['url']      | $cf['site']['urls'][ SITE_STATUS ]
     *
     * Si noti che $cf['site']['ietf'] viene dichiarata successivamente in _src/_config/_070.localization.php
     *
     * applicazione della configurazione extra del sito
     * ------------------------------------------------
     * In questa sezione vengono applicate le configurazioni extra del sito, se presenti nei file di configurazione JSON e YAML.
     *
     *
     *
     *
     *
     * TODO creare una scorciatoia anche per $cf['localization']['language']['ietf'] tipo $cf['site']['ietf']
     * TODO documentare $cf['site']['url'] e $cf['site']['root']
     *
     *
     *
     */

    /**
     * definizione delle costanti del sito
     * ===================================
     * In questa sezione vengono definite alcune costanti necessarie al funzionamento del sito, se non sono già state
     * dichiarate in precedenza nel file /src/010.site.php.
     * 
     */

    // carattere di default per la separazione delle parole negli URL
    if( ! defined( 'URL_WORD_SEPARATOR' ) ) {
        define( 'URL_WORD_SEPARATOR' , '-' );
    }

    // carattere di default per separare il titolo del sito da quello della pagina nel tag <title>
    if( ! defined( 'TITLE_SEPARATOR' ) ) {
        define( 'TITLE_SEPARATOR', ' | ' );
    }

    /**
     * elaborazione delle variabili derivate del sito
     * ==============================================
     * In questa sezione vengono elaborate le informazioni del sito per ricavare dati che derivano da quelli già presenti.
     * 
     */

    // elaboro gli URL del sito a partire da protocollo, host, dominio e cartella
    foreach( array_keys( $cf['site']['domains'] ) as $status ) {

        $cf['site']['urls'][ $status ] =
        $cf['site']['protocols'][ $status ] . '://' .
        (
            ( ! empty( $cf['site']['hosts'][ $status ] ) )
            ? $cf['site']['hosts'][ $status ] . ( ( ! empty( $cf['site']['domains'][ $status ] ) ) ? '.' : NULL )
            : NULL 
        ).
        $cf['site']['domains'][ $status ] . '/' .
        ( ( isset( $cf['site']['folders'][ SITE_STATUS ] ) ) ? $cf['site']['folders'][ SITE_STATUS ] : NULL );

    }

    /**
     * creazione delle scorciatoie
     * ===========================
     * In questa sezione vengono create le scorciatoie (come puntatori) ai valori utilizzati più di frequente.
     * 
     */

    // URL corrente del sito
    $cf['site']['home']                     = &$cf['site']['homes'][ SITE_STATUS ];

    // URL corrente del sito
    $cf['site']['url']                      = &$cf['site']['urls'][ SITE_STATUS ];

    // dominio corrente del sito
    $cf['site']['domain']                   = &$cf['site']['domains'][ SITE_STATUS ];

    // host corrente del sito
    $cf['site']['host']                     = &$cf['site']['hosts'][ SITE_STATUS ];

    // FQDN corrente del sito
    $cf['site']['fqdn']                     = trim( $cf['site']['host'] . ( ( ! empty( $cf['site']['domain'] ) ) ? '.' . $cf['site']['domain'] : NULL ), ". \t\n\r\0\x0B" );

    // percorso della cartella root del sito
    $cf['site']['root']                     = '/' . ( ( isset( $cf['site']['folders'][ SITE_STATUS ] ) ) ? $cf['site']['folders'][ SITE_STATUS ] : NULL );

    // pulisco la variabile REDIRECT_URL per far corrispondere la cartella base alla pagina home
    // TODO fare il debug e i test del framework nelle sottocartelle
    if( isset( $_SERVER['REDIRECT_URL'] ) ) {
        $_SERVER['REDIRECT_URL']            = substr( $_SERVER['REDIRECT_URL'], strlen( $cf['site']['root'] ) );
    }

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     * 
     * 
     */

    // configurazione extra
    if( isset( $cx['site'] ) ) {
        $cf['site'] = array_replace_recursive( $cf['site'], $cx['site'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento dell'array $ct
    $ct['site'] = &$cf['site'];

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // dieText( print_r( $cf['site'], true ) );
    // echo 'OUTPUT';
