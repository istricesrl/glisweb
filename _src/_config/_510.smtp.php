<?php

    /**
     * server e profili SMTP
     *
     * In questo file sono impostati i profili di funzionamento di SMTP e i parametri di
     * configurazione dei server disponibili.
     *
     * introduzione
     * ============
     * Il framework utilizza SMTP per inviare mail di diverso tipo, dalle notifiche per
     * determinati eventi fino all'invio di comunicazioni, anche massicce. Pur non essendo
     * progettato per gestire vere e proprie campagne DEM, il framework integra diverse
     * funzioni di CRM e pertanto è stata posta una particolare attenzione nello sviluppo
     * di un sottosistema di gestione delle code e dell'invio delle mail robusto ed
     * efficiente.
     *
     * Analogamente a quanto già visto per la cache e per i database, il sottoarray
     * $cf['smtp'] comprende sia la configurazione dei server che quella dei profili
     * disponibili oltre al link simbolico al profilo corrente.
     *
     * array di configurazione dei server
     * ----------------------------------
     * L'array $cf['smtp']['servers'] contiene la descrizione dei server SMTP abilitati
     * nell'installazione corrente; ogni server è identificato in chiave dal proprio nome
     * ed è descritto dalle seguenti chiavi:
     *
     * chiave           | dettagli
     * -----------------|-----------------------------------------------------------------------
     * address          | l'indirizzo (nome host o IP) del server
     * port             | la porta del server (default 25)
     * username         | il nome utente per la connessione (se richiesto)
     * password         | la password per la connessione (se richiesta)
     * ssl              | vero se il server richiede SSL, falso altrimenti, NULL se indifferente
     *
     * array di configurazione dei profili
     * -----------------------------------
     * Ogni profilo di funzionamento del sito può avere associati diversi server, come già visto
     * per i database e per la cache; anche in questo caso i server disponibili sono
     * elencati nella chiave 'servers':
     *
     * chiave           | dettagli
     * -----------------|-----------------------------------------------------------------------
     * servers          | un array contenente i nomi dei server attivi
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // server disponibili
	$cf['smtp']['servers']				= array();

    // profili di funzionamento
	$cf['smtp']['profiles'][ DEVELOPEMENT ]		=
	$cf['smtp']['profiles'][ TESTING ]		=
	$cf['smtp']['profiles'][ PRODUCTION ]		= array();

    // link al server corrente
	$cf['smtp']['server']				= NULL;

    // configurazione extra
	if( isset( $cx['smtp'] ) ) {
	    $cf['smtp'] = array_replace_recursive( $cf['smtp'], $cx['smtp'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['smtp'] ) ) {
	    $cf['smtp'] = array_replace_recursive( $cf['smtp'], $cf['site']['smtp'] );
	}

    // debug
	// print_r( $cf['contents']['pages']['licenza']['content'] );
	// print_r( $cf['contents']['page'] );
	// print_r( $ct['page'] );
