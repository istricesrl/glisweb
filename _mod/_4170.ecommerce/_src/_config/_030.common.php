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

    // pagine di default
    $cf['ecommerce']['pages']['acquisto']		    = 'carrello';			                        // pagina di visualizzazione articoli aggiunti, gestisce anche l'aggiunta vera e propria
    $cf['ecommerce']['pages']['dettagli']		    = 'carrello';			                        // usare carrello_dettagli per two-step checkout
    $cf['ecommerce']['pages']['riepilogo']		    = 'carrello_riepilogo';		                    // gestisce i dettagli inserendoli nel carrello e prepara il pacchetto dati per il perfezionamento
    $cf['ecommerce']['pages']['esito']			    = 'carrello_esito';		                        // gestisce il perfezionamento dell'ordine e presenta il risultato all'utente
    $cf['ecommerce']['pages']['successo']			= 'carrello_successo';		                    // pagina di atterraggio per il pagamento avvenuto con successo presso provider esterni di pagamento
    $cf['ecommerce']['pages']['errore']			    = 'carrello_fallimento';		                // pagina di atterraggio per gli errori dei provider esterni di pagamento

    // profili di funzionamento
	$cf['ecommerce']['profiles'][ DEVELOPEMENT ]	=
	$cf['ecommerce']['profiles'][ TESTING ]		    =
	$cf['ecommerce']['profiles'][ PRODUCTION ]	    = array(
        'provider' => array(
            'contanti' => array(
                'id'            => 'contanti',                                                      // ID del provider per le tendine
                'action'        => 'carrello_checkout',                                             // pagina per l'action del form di riepilogo
                'method'        => 'post',                                                          // metodo per il form di riepilogo
                '__label__'     => 'contrassegno'                                                   // etichetta del provider per le tendine
            ),
            'nexi' => array(
                'id'            => 'nexi',                                                          // ID del provider per le tendine
                'alias'         => NULL,                                                            // 
                'key'           => NULL,                                                            // 
                'action_url'    => 'https://int-ecommerce.nexi.it/ecomm/ecomm/DispatcherServlet',   // pagina per l'action del form di riepilogo
                'method'        => 'post',                                                          // metodo per il form di riepilogo
                'success'       => 'carrello_esito',                                                // pagina di ritorno in caso di pagamento effettuato con successo
                'error'         => 'carrello',                                                      // pagina di ritorno in caso di interruzione della procedura di pagamento
                'listener'      => '_mod/_4170.ecommerce/_src/_api/_nexi.listener.php',             // listener per la conferma di pagamento in background
                '__label__'     => 'carta di credito'                                               // etichetta del provider per le tendine
            ),
            'paypal' => array(
                'id'            => 'paypal',                                                        // ID del provider per le tendine
                'business'      => NULL,                                                            // 
                'action_url'    => 'https://www.sandbox.paypal.com/cgi-bin/webscr',                 // pagina per l'action del form di riepilogo
                'method'        => 'post',                                                          // metodo per il form di riepilogo
                'return'        => 'carrello_esito',                                                // pagina di ritorno in caso di pagamento completato con successo o fallito
                'cancel'        => 'carrello',                                                      // pagina di ritorno in caso di interruzione della procedura di pagamento
                'listener'      => '_mod/_4170.ecommerce/_src/_api/_paypal.listener.php',           // listener per la conferma di pagamento in background
                '__label__'     => 'PayPal'                                                         // etichetta del provider per le tendine
            ),
            'paypal-advanced' => array(
                'id'            => 'paypal-advanced',                                               // ID del provider per le tendine
                'business'      => NULL,                                                            // 
                'client_id'     => NULL,                                                            // 
                'client_secret' => NULL,                                                            // 
                'token_api'     => 'https://api-m.sandbox.paypal.com/v1/identity/generate-token',   // API alla quale richiedere il Client Token
                'order_api'     => '',                                                              // 
                'capture_api'   => '',                                                              // 
                '__label__'     => 'PayPal Advanced'                                                // etichetta del provider per le tendine
            )
        )
    );

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
     */

    // configurazione extra
	if( isset( $cx['ecommerce'] ) ) {
	    $cf['ecommerce'] = array_replace_recursive( $cf['ecommerce'], $cx['ecommerce'] );
	}

    // configurazione extra per sito
	if( isset( $cf['site']['ecommerce'] ) ) {
	    $cf['ecommerce'] = array_replace_recursive( $cf['ecommerce'], $cf['site']['ecommerce'] );
	}

    // collegamento all'array $ct
	$ct['ecommerce']					            = &$cf['ecommerce'];
