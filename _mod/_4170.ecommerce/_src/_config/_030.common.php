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
                'action'        => 'carrello_esito',                                                // pagina per l'action del form di riepilogo
                'method'        => 'post',                                                          // metodo per il form di riepilogo
                '__label__'     => 'contrassegno'                                                   // etichetta del provider per le tendine
            ),
            'nexi' => array(
                'id'            => 'nexi',                                                          // ID del provider per le tendine
                'alias'         => NULL,                                                            // 
                'key'           => NULL,                                                            // 
                'action'        => 'https://int-ecommerce.nexi.it/ecomm/ecomm/DispatcherServlet',   // pagina per l'action del form di riepilogo
                'method'        => 'post',                                                          // metodo per il form di riepilogo
                'success'       => 'carrello_successo',                                             // pagina di ritorno in caso di pagamento effettuato con successo
                'error'         => 'carrello_fallimento',                                           // pagina di ritorno in caso di pagamento fallito
                'listener'      => '_mod/_4170.ecommerce/_src/_api/_nexi.listener.php',             // listener per la conferma di pagamento in background
                '__label__'     => 'carta di credito'                                               // etichetta del provider per le tendine
            ),
            'paypal' => array(
                'id'            => 'paypal',                                                        // ID del provider per le tendine
                'business'      => NULL,                                                            // 
                'action'        => 'https://www.sandbox.paypal.com/cgi-bin/webscr',                 // pagina per l'action del form di riepilogo
                'method'        => 'post',                                                          // metodo per il form di riepilogo
                'return'        => 'carrello_esito',                                                // pagina di ritorno in caso di pagamento completato con successo o fallito
                'cancel_return' => 'carrello',                                                      // pagina di ritorno in caso di interruzione della procedura di pagamento
                'listener'      => '_mod/_4170.ecommerce/_src/_api/_paypal.listener.php',           // listener per la conferma di pagamento in background
                '__label__'     => 'PayPal'                                                         // etichetta del provider per le tendine
            )
        )
    );

    /**
     * NOTA SU NEXI
     * per avere i dati di test (alias, key, e numeri di carte fittizie) registrarsi su https://ecommerce.nexi.it/area-test
     * 
     * NOTA SU PAYPAL
     * per avere i dati di test (business e account clienti fittizi) registrarsi su https://developer.paypal.com/developer/accounts/
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
