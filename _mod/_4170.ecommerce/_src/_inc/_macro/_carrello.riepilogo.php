<?php

    /**
     * pagina di riepilogo prima del pagamento vero e proprio
     * 
     * lo scopo di questa pagina, parlando in termini generici, è quello di creare le condizioni necessarie al pagamento vero e proprio; cosa questo
     * significhi di volta in volta dipende dal metodo di pagamento in uso
     * 
     * introduzione
     * ============
     * Il processo di pagamento si articola su diversi step; nel caso dell'e-commerce l'oggetto retrostante al pagamento è il carrello, e il pagamento viene
     * registrato sul carrello stesso dopodiché il documento viene creato a posteriori o contestualmente, mentre per il pagamento di righe della tabella
     * pagamenti l'oggetto retrostante è il documento che può essere già esistente, creato contestualmente al pagamento, o anche creato successivamente
     * a questo.
     * 
     * Da un punto di vista concettuale, questa macro è corrispondente alla macro _mod/_F030.pagamenti/_src/_inc/_macro/_pagamento.riepilogo.php del
     * modulo pagamenti.
     * 
     * pagamenti con checkout implicito e pagamenti tramite provider esterno
     * ---------------------------------------------------------------------
     * Dall'oggetto retrostante (carrello o pagamento) il percorso di pagamento segue due strade diverse per i pagamenti con checkout implicito e per quelli
     * che si appoggiano a un provider esterno per il pagamento. Nel primo gruppo troviamo il pagamento in contanti alla consegna, il pagamento con bonifico
     * bancario, e così via. Nel secondo gruppo troviamo invece PayPal, Nexi, Satispay, e simili.
     * 
     * Nel primo caso, il percorso di chiusura dell'ordine non passa dalla pagina di riepilogo, ma va alla pagina di checkout, dove viene registrato semplicemente
     * il fatto che l'utente ha concluso l'ordine e che il pagamento verrà perfezionato offline.
     * 
     * Nel secondo caso il percorso di chiusura dell'ordine passa per il riepilogo, per l'interazione con il provider di pagamento, e termina sulla pagina di
     * esito ma coinvolge anche l'API di pagamento specifica per il provider scelto, il cui compito è registrare materialmente l'avvenuto pagamento; la pagina
     * di esito infatti è solo informativa per il cliente ma non salva alcun dato.
     * 
     */

    // se è impostato un provider di pagamento
    if( isset( $_SESSION['carrello']['provider_pagamento'] ) && ! empty( $_SESSION['carrello']['provider_pagamento'] ) ) {

        // shortcut per il carrello
        $c                                                  = $_SESSION['carrello'];

        // shortcut per la lingua
        $l                                                  = $cf['localization']['language']['ietf'];

        // shortcut per il profilo
        $k                                                  = $cf['ecommerce']['profile']['provider'][ $_SESSION['carrello']['provider_pagamento'] ];

        // URL espliciti
        $k['action_url']                                    = ( ! isset( $k['action_url'] ) || empty( $k['action_url'] ) ) ? ( ( isset( $k['action'] ) ) ? $cf['contents']['pages'][ $k['action'] ]['url'][ $l ] : NULL ) : $k['action_url'];

        // dati per la costruzione del modulo
        $ct['etc']['meta']['method']	                    = ( ! isset( $k['method'] ) ) ? NULL : $k['method'];		    // metodo di chiamata al server
        $ct['etc']['meta']['action']                        = $k['action_url'];                                             // server da chiamare
        $ct['etc']['meta']['autosubmit']                    = ( isset( $k['autosubmit'] ) ) ? $k['autosubmit'] : false;     // opzione autosubmit per la pagina di riepilogo

        // configurazione riepilogo e ambiente di pagamento in base al provider scelto
        switch( $_SESSION['carrello']['provider_pagamento'] ) {

            // pagamento in contrassegno
            case 'contanti':

                // dati del modulo
                    $ct['etc']['fields']['id']		        = $c['id'];											            // id del carrello
        
            break;

            // pagamento con PayPal
            case 'paypal':

                // preparazione del totale
                    $c['prezzo_lordo_finale']               = str_replace( ',', '.', sprintf( '%01.2f', $c['prezzo_lordo_finale'] ) );

                // URL espliciti
                    $k['return_url']                        = ( ! isset( $k['return_url'] ) || empty( $k['return_url'] ) ) ? $cf['contents']['pages'][ $k['return'] ]['url'][ $l ] : $k['return_url'];
                    $k['cancel_url']                        = ( ! isset( $k['cancel_url'] ) || empty( $k['cancel_url'] ) ) ? $cf['contents']['pages'][ $k['cancel'] ]['url'][ $l ] : $k['cancel_url'];

                // dati del modulo
                    $ct['etc']['fields']['item_name']		= 'ordine e-commerce n. '.$c['id'];							// nome del carrello
                    $ct['etc']['fields']['item_number']		= $c['id'];										            // ID del carrello
                    $ct['etc']['fields']['cmd']			    = '_xclick';										        // comando inviato al server
                    $ct['etc']['fields']['business']		= $k['business'];									        // indirizzo e-mail dell'account
                    $ct['etc']['fields']['amount']		    = $c['prezzo_lordo_finale'];			                    // totale a pagare
                    $ct['etc']['fields']['currency_code']	= 'EUR';										            // TODO valuta del carrello
                    $ct['etc']['fields']['image']		    = 'http://www.paypal.com/it_IT/i/btn/x-click-but01.gif';	// bottone "paga adesso"
                    $ct['etc']['fields']['return']		    = $k['return_url'];                                         // pagina di pagamento effettuato con successo
                    $ct['etc']['fields']['cancel_return']	= $k['cancel_url'];	                                        // pagina di annullamento del pagamento
                    $ct['etc']['fields']['notify_url']		= $cf['site']['url'] . $k['listener'];						// pagina dell'API di ricezione conferma

            break;

            // pagamento con PayPal Advanced Checkout
            case 'paypal-advanced':

                $ct['etc']['client_token'] = paypalAdvancedGetClientToken( $k );

                // debug
                    // print_r( $ct['etc'] );
                    // die( print_r( $k, true ) );
                    // print_r( $result );

            break;

            // pagamento con Nexi
            case 'nexi':

                // preparazione del totale
                    $c['prezzo_lordo_finale']               = str_replace( '.', ',', sprintf( '%01.2f', $c['prezzo_lordo_finale'] ) );

                // URL espliciti
                    $k['success_url']                       = ( ! isset( $k['success_url'] ) || empty( $k['success_url'] ) ) ? $cf['contents']['pages'][ $k['success'] ]['url'][ $l ] : $k['success_url'];
                    $k['error_url']                         = ( ! isset( $k['error_url'] ) || empty( $k['error_url'] ) ) ? $cf['contents']['pages'][ $k['error'] ]['url'][ $l ] : $k['error_url'];

                // dati per la costruzione del modulo
                    $ct['etc']['meta']['ct']		        = explode( ' ', microtime() );	                            // timestamp corrente
                    $ct['etc']['meta']['macKey']	        = $k['key'];											    // chiave mac

                // dati del modulo
                    $ct['etc']['fields']['codTrans']        = $c['id'];										            // ID del carrello
                    $ct['etc']['fields']['importo']         = $c['prezzo_lordo_finale'];                                // totale a pagare
                    $ct['etc']['fields']['alias']           = $k['alias'];											    // insegna del negozio
                    $ct['etc']['fields']['divisa']          = 'EUR';											        // TODO valuta del carrello
                    $ct['etc']['fields']['mail']            = $c['intestazione_mail'];									// mail del cliente
                    $ct['etc']['fields']['url']             = $k['success_url'];					                    // pagina di pagamento effettuato con successo
                    $ct['etc']['fields']['url_back']        = $k['error_url'];						                    // pagina di problemi con il pagamento
                    $ct['etc']['fields']['urlpost']         = $cf['site']['url'] . $k['listener'];					    // pagina dell'API di ricezione conferma
                    $ct['etc']['fields']['languageId']      = 'ITA';											        // TODO codice della lingua

                // calcolo del mac
                    $ct['etc']['fields']['mac']             = sha1(
                        'codTrans=' . $ct['etc']['fields']['codTrans'] . 
                        'divisa=EURimporto=' . $ct['etc']['fields']['importo'] .
                        $ct['etc']['meta']['macKey']
                    );                    

            break;

            case 'monetaweb':

                $k['success_url'] = $cf['contents']['pages'][ $k['success'] ]['url'][ $l ];
                $k['error_url'] = $cf['contents']['pages'][ $k['error'] ]['url'][ $l ];

                // richiedo il PaymentID e l'URL per il redirect
                $paymentID = monetawebGetPaymentDetails( $c, $k );

                // modifico la destinazione del form di riepilogo
                $ct['etc']['meta']['action'] = $paymentID[2];

            break;

        }

    }
