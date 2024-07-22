<?php

    /**
     * server e profili ecommerce
     *
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

    // debug
    // print_r( $_REQUEST['__pagamenti__'] );

    // pagine di default
    $cf['ecommerce']['pages']['acquisto']		    = 'carrello';			                            // pagina di visualizzazione articoli aggiunti, gestisce anche l'aggiunta vera e propria
    $cf['ecommerce']['pages']['dettagli']		    = 'carrello';			                            // usare carrello_dettagli per two-step checkout
    $cf['ecommerce']['pages']['riepilogo']		    = 'carrello.riepilogo';		                        // gestisce i dettagli inserendoli nel carrello e prepara il pacchetto dati per il perfezionamento
    $cf['ecommerce']['pages']['esito']			    = 'carrello.esito';		                            // gestisce il perfezionamento dell'ordine e presenta il risultato all'utente
    $cf['ecommerce']['pages']['successo']			= 'carrello.successo';		                        // pagina di atterraggio per il pagamento avvenuto con successo presso provider esterni di pagamento
    $cf['ecommerce']['pages']['errore']			    = 'carrello.fallimento';		                    // pagina di atterraggio per gli errori dei provider esterni di pagamento

    // configurazioni di default
    // NOTA i default per i campi del carrello sono in 035 commons
    // $cf['ecommerce']['defaults']['cassa']['id_tipologia_documento']     = 8;                         // tipologia di documento da generare di default in cassa
    // $cf['ecommerce']['defaults']['cassa']['strategia_fatturazione']     = 'SINGOLA';                 // strategia di generazione dei documenti da usare di default in cassa

    // profilo di funzionamento per DEV
	$cf['ecommerce']['profiles'][ DEVELOPEMENT ]	= array(
        'fatturazione' => array(
            'merchant' => NULL,                                                                         // ID dell'anagrafica merchant (per l'emissione dei documenti)
            'magazzino' => NULL,                                                                        // ID del mastro dal quale scaricare la merce (per l'emissione dei documenti)
            'cassa' => NULL,                                                                            // ID del mastro sul quale caricare gli incassi (per l'emissione dei documenti)
            'documento' => NULL,                                                                        // ID della tipologia di documento di default (per l'emissione dei documenti)
            'strategia' => NULL                                                                         // strategia di fatturazione di default (per l'emissione dei documenti)
        ),
        'provider' => array(
            'contanti' => array(
                'id'            => 'contanti',                                                          // ID del provider per le tendine
                'available'     => true,                                                                // disponibilità del provider
                'modalita'      => 1,                                                                   // ID della modalità di pagamento (per l'emissione dei documenti)
                'action'        => 'carrello.checkout',                                                 // pagina per l'action del form di riepilogo
                'method'        => 'post',                                                              // metodo per il form di riepilogo
                'autosubmit'    => false,                                                               // autosubmit del modulo di riepilogo
                '__label__'     => 'contanti'                                                           // etichetta del provider per le tendine
            ),
            'contrassegno' => array(
                'id'            => 'contrassegno',                                                      // ID del provider per le tendine
                'available'     => true,                                                                // disponibilità del provider
                'modalita'      => 1,                                                                   // ID della modalità di pagamento (per l'emissione dei documenti)
                'action'        => 'carrello.checkout',                                                 // pagina per l'action del form di riepilogo
                'method'        => 'post',                                                              // metodo per il form di riepilogo
                'autosubmit'    => false,                                                               // autosubmit del modulo di riepilogo
                '__label__'     => 'contrassegno'                                                       // etichetta del provider per le tendine
            ),
            'bonifico' => array(
                'id'            => 'bonifico',                                                          // ID del provider per le tendine
                'available'     => true,                                                                // disponibilità del provider
                'modalita'      => 5,                                                                   // ID della modalità di pagamento (per l'emissione dei documenti)
                'action'        => 'carrello.checkout',                                                 // pagina per l'action del form di riepilogo
                'method'        => 'post',                                                              // metodo per il form di riepilogo
                'autosubmit'    => false,                                                               // autosubmit del modulo di riepilogo
                '__label__'     => 'bonifico anticipato'                                                // etichetta del provider per le tendine
            ),
            'nexi' => array(
                'id'            => 'nexi',                                                              // ID del provider per le tendine
                'available'     => true,                                                                // disponibilità del provider
                'modalita'      => 8,                                                                   // ID della modalità di pagamento (per l'emissione dei documenti)
                'alias'         => NULL,                                                                // 
                'key'           => NULL,                                                                // 
                'action_url'    => 'https://int-ecommerce.nexi.it/ecomm/ecomm/DispatcherServlet',       // pagina per l'action del form di riepilogo
                'method'        => 'post',                                                              // metodo per il form di riepilogo
                'autosubmit'    => false,                                                               // autosubmit del modulo di riepilogo
                'success'       => 'carrello.esito',                                                    // pagina di ritorno in caso di pagamento effettuato con successo
                'error'         => 'carrello',                                                          // pagina di ritorno in caso di interruzione della procedura di pagamento
                'listener'      => '_mod/_4170.ecommerce/_src/_api/_nexi.listener.php',                 // listener per la conferma di pagamento in background
                '__label__'     => 'carta di credito'                                                   // etichetta del provider per le tendine
            ),
            'monetaweb' => array(
                'id'            => 'monetaweb',                                                         // ID del provider per le tendine
                'available'     => true,                                                                // disponibilità del provider
                'modalita'      => 8,                                                                   // ID della modalità di pagamento (per l'emissione dei documenti)
                'init_api'      => 'https://www.monetaonline.it/MPI2/servlet/PaymentInitHTTPServlet',   // API che restituisce orderId:paymentUrl
                'term_id'       => NULL,                                                                // ID del terminale
                'term_passwd'   => NULL,                                                                // password del terminale
                'success'       => 'carrello.esito',                                                    // pagina di ritorno in caso di pagamento effettuato con successo
                'error'         => 'carrello',                                                          // pagina di ritorno in caso di interruzione della procedura di pagamento
                'listener'      => '_mod/_4170.ecommerce/_src/_monetaweb/_nexi.listener.php',           // listener per la conferma di pagamento in background
                '__label__'     => 'carta di credito'                                                   // etichetta del provider per le tendine
            ),
            'paypal' => array(
                'id'            => 'paypal',                                                            // ID del provider per le tendine
                'available'     => true,                                                                // disponibilità del provider
                'modalita'      => 24,                                                                  // ID della modalità di pagamento (per l'emissione dei documenti)
                'business'      => NULL,                                                                // 
                'action_url'    => 'https://www.sandbox.paypal.com/cgi-bin/webscr',                     // pagina per l'action del form di riepilogo
                'method'        => 'post',                                                              // metodo per il form di riepilogo
                'autosubmit'    => false,                                                               // autosubmit del modulo di riepilogo
                'return'        => 'carrello.esito',                                                    // pagina di ritorno in caso di pagamento completato con successo o fallito
                'cancel'        => 'carrello',                                                          // pagina di ritorno in caso di interruzione della procedura di pagamento
                'listener'      => '_mod/_4170.ecommerce/_src/_api/_paypal.listener.php',               // listener per la conferma di pagamento in background
                '__label__'     => 'PayPal'                                                             // etichetta del provider per le tendine
            ),
            'paypal-advanced' => array(
                'id'            => 'paypal-advanced',                                                   // ID del provider per le tendine
                'available'     => true,                                                                // disponibilità del provider
                'modalita'      => 24,                                                                  // ID della modalità di pagamento (per l'emissione dei documenti)
                'advanced'      => false,                                                               // impostare a true per consentire il pagamento con carta dal sito
                'business'      => NULL,                                                                // 
                'client_id'     => NULL,                                                                // 
                'client_secret' => NULL,                                                                // 
                'auth_api'      => 'https://api-m.sandbox.paypal.com/v1/oauth2/token',                  // API alla quale richiedere l'Access Token
                'token_api'     => 'https://api-m.sandbox.paypal.com/v1/identity/generate-token',       // API alla quale richiedere il Client Token
                'order_api'     => 'https://api-m.sandbox.paypal.com/v2/checkout/orders',               // API alla quale richiedere l'Order ID
                'return'        => 'carrello.esito',                                                    // pagina di ritorno in caso di pagamento completato con successo o fallito
                'cancel'        => 'carrello',                                                          // pagina di ritorno in caso di interruzione della procedura di pagamento
                '__label__'     => 'PayPal Advanced'                                                    // etichetta del provider per le tendine
            )
        )
    );

    // profili di funzionamento per TEST e STABLE
	$cf['ecommerce']['profiles'][ TESTING ]		    =
	$cf['ecommerce']['profiles'][ PRODUCTION ]	    =     array();

    /**
     * NOTA
     * nei parametri dei provider, per quanto riguarda le pagine di ritorno, si intende:
     * 
     * - return è una pagina neutra, che determina in base ai dati ricevuti se c'è stato un successo o un fallimento nel pagamento
     * - success è una pagina di successo nel pagamento
     * - error è una pagina di errore nel pagamento
     * - cancel è la pagina per l'annullamento del pagamento da parte dell'utente
     * 
     * per quanto riguarda la pagina action, nel caso dei provider esterni punta al provider stesso, altrimenti è la pagina di chiusura del
     * carrello per modalità di pagamento offline (contrassegno, bonifico, e simili) la cui macro si occupa della chiusura del carrello; la chiusura
     * del carrello viene fatta invece dai listener per le modalità di pagamento online (PayPal, Nexi e simili)
     * 
     */

    /**
     * NOTA SU NEXI
     * per avere i dati di test (alias, key, e numeri di carte fittizie) registrarsi su https://ecommerce.nexi.it/area-test
     * per i test con Nexi bisogna utilizzare un importo prefissato (vedi documentazione)
     * 
     * NOTA SU PAYPAL
     * per avere i dati di test (business e account clienti fittizi) registrarsi su https://developer.paypal.com/developer/accounts/
     * i dati sono nella pagina https://developer.paypal.com/developer/applications/
     * 
     * NOTA SU PAYPAL
     * l'URL delle API di produzione è https://api-m.paypal.com anziché https://api-m.sandbox.paypal.com
     * 
     */

    // campi di base del carrello
    $cf['ecommerce']['fields']['carrello']      = array(
        'id'                                    => array( 'tipe' => 'int',      'default' => NULL ),
        // 'id_iva'                             => array( 'tipe' => 'int',      'default' => NULL ),
        'id_listino'                            => array( 'tipe' => 'int',      'default' => 1 ),
        'id_zona'                               => array( 'tipe' => 'int',      'default' => 1 ),
        'session'                               => array( 'type' => 'string',   'default' => NULL ),
        'destinatario_id_anagrafica'            => array( 'type' => 'string',   'default' => NULL ),
        'destinatario_id_tipologia_anagrafica'  => array( 'type' => 'string',   'default' => NULL ),
        'destinatario_id_account'               => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_id_anagrafica'            => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_id_tipologia_anagrafica'  => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_id_account'               => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_nome'                     => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_cognome'                  => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_denominazione'            => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_sdi'                      => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_pec'                      => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_codice_fiscale'           => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_partita_iva'              => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_indirizzo'                => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_cap'                      => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_citta'                    => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_id_provincia'             => array( 'tipe' => 'int',      'default' => NULL ),
        'intestazione_id_stato'                 => array( 'tipe' => 'int',      'default' => 1 ),
        'intestazione_telefono'                 => array( 'type' => 'string',   'default' => NULL ),
        'intestazione_mail'                     => array( 'type' => 'string',   'default' => NULL ),
        'provider_pagamento'                    => array( 'type' => 'string',   'default' => NULL ),
        'fatturazione_id_tipologia_documento'   => array( 'type' => 'string',   'default' => 8 ),
        'fatturazione_sezionale'                => array( 'type' => 'string',   'default' => 'E' ),
        'fatturazione_strategia'                => array( 'type' => 'string',   'default' => 'SINGOLA', 'values' => array( 'SINGOLA', 'MULTIPLA', NULL ) ),
        // 'spam_check'                            => array( 'type' => 'float',    'default' => NULL ),
        // 'spam_score'                            => array( 'tipe' => 'int',      'default' => NULL ),
        'codice_coupon'                         => array( 'type' => 'string',   'default' => NULL ),
        'timestamp_checkout'                    => array( 'tipe' => 'int',      'default' => NULL ),
    );

    // TODO occhio la timestamp_checkout dev'essere modificabile solo se l'utente ha i privilegi giusti (aggiuntere un campo all'array?)

    // TODO
    // aggiungere $cf['utm']['fields'] ai campi del carrello

    $cf['ecommerce']['fields']['articoli']      = array(
        'id'                            => array( 'tipe' => 'int',      'default' => NULL ),
        'id_articolo'                   => array( 'tipe' => 'string',   'default' => NULL ),
        'id_listino'                    => array( 'tipe' => 'int',      'default' => NULL ),
        'id_iva'                        => array( 'tipe' => 'int',      'default' => NULL ),
        'destinatario_id_anagrafica'    => array( 'type' => 'string',   'default' => NULL ),
        'id_mastro_provenienza'         => array( 'type' => 'int',      'default' => NULL ),
        'id_rinnovo'                    => array( 'type' => 'int',      'default' => NULL ),
        'id_progetto'                   => array( 'type' => 'string',   'default' => NULL ),
        'quantita'                      => array( 'tipe' => 'int',      'default' => NULL ),
        'sconto_percentuale'            => array( 'tipe' => 'int',      'default' => NULL ),
        'sconto_valore'                 => array( 'tipe' => 'int',      'default' => NULL ),
    );

    // TODO occhio le colonne degli sconti devono essere modificabili solo se l'utente ha i privilegi giusti (aggiuntere un campo all'array?)
