<?php

    /**
     * configurazioni per la privacy
     *
     * in questo file vengono settate le configurazioni di default per la privacy, che vanno poi
     * specificate in custom per essere compliant con la normativa vigente
     * 
     * introduzione
     * ============
     * Le configurazioni per la privacy sono divise in tre macro aree:
     * 
     * - dati dei soggetti coinvolti
     * - dati dei cookie
     * - dati dei consensi relativi ai moduli
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

    // inizializzazione
    $cf['privacy'] = array();

    /**
     * dati delle persone coinvolte
     * ============================
     * Le persone coinvolte sono il titolare del trattamento, i responsabili del trattamento, gli incaricati del trattamento,
     * il data protection officer (DPO) ed eventuali soggetti terzi coinvolti.
     * 
     * 
     */

    // dati del titolare del trattamento
    $cf['privacy']['persone']['titolare'] = array();

    /**
     * dati dei cookie
     * ===============
     * 
     * 
     */

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
     * dati dei moduli e dei consensi
     * ==============================
     * 
     * 
     * 
     */

    // modulo di default
    $cf['privacy']['moduli']['default'] = array(
        'titolo' => array(
            'it-IT' => 'modulo di adesione alla newsletter',
            'en-GB' => 'form for joining the newsletter'
        ),
        'descrizione' => array(
            'it-IT' => 'Questo modulo può essere utilizzato dagli utenti per aderire alla newsletter.',
            'en-GB' => 'This form can be used by users to join the newsletter.'
        ),
        'consensi' => array(
            'PRIVACY_POLICY' => array(
                'informativa' => array(
                    'it-IT' => 'richiesta adesione alla newsletter',
                    'en-GB' => 'request to join the newsletter'
                ),
                'label' => array(
                    'it-IT' => 'la privacy e cookie policy del sito',
                    'en-GB' => 'privacy and cookie policy of the site'
                ),
                'action' => 'letto_e_accetto',
                'page' => 'privacy',
                'required' => true
            )
        )
    );

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // echo 'OUTPUT';

