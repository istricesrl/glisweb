<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * TODO documentare bene tutta questa cosa della privacy e in particolare:
     * - la gestione dei cookie (come il framework gestisce i cookie e i relativi consensi)
     * - la gestione dei dati inseriti nei form dagli utenti e i relativi consensi
     * - la generazione della privacy & cookie policy, come va configurato il framework per farla uscire giusta, eccetera
     *
     *
     * TODO applicare la strategia della configurazione extra per sito anche ai vari slack, google, criteo, ecc.
     * TODO rimuovere quel brutto codice che fa il controllo della configurazione per sito nei vari slack, google, criteo, ecc.
     *
     * TODO i cookie di Google reCAPTCHA sono cookie tecnici o di profilazione?
     * 
     * TODO documentare
     * 
     *
     */

    // debug
    // error_reporting( E_ALL );
    // ini_set( 'display_errors', TRUE );
    // echo 'OUTPUT';

    /**
     * variabili generali per la privacy
     * =================================
     * 
     * 
     */

    // inizializzazione
    $cf['privacy'] = array();

    // dichiarazione dell'uso di cookie propri tecnici (cookie di sessione)
    $cf['privacy']['cookie']['propri']['tecnici'] = array(
        'sessione' => array(
            'id' => 'PHPSESSID',
            'nome' => array( 'it-IT' => 'cookie di sessione' ),
            'motivazione' => array( 'it-IT' => 'gestione della sessione utente' ),
            'descrizione' => array( 'it-IT' => 'cookie di sessione per la gestione della sessione utente, viene eliminato alla chiusura del browser' ),
            'conservazione' => array( 'it-IT' => 'fino alla chiusura del browser' ),
        ),
        'privacy' => array(
            'id' => 'privacy',
            'nome' => array( 'it-IT' => 'cookie per la gestione della privacy' ),
            'motivazione' => array( 'it-IT' => 'gestione dei consensi della privacy' ),
            'descrizione' => array( 'it-IT' => 'cookie per la gestione dei consensi della privacy, viene eliminato alla chiusura del browser' ),
            'conservazione' => array( 'it-IT' => 'fino alla chiusura del browser' ),
        ),
    );

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // echo 'OUTPUT';

