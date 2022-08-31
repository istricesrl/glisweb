<?php

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
                    // print_r( $k );
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

        }

    }
