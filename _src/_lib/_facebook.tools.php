<?php

    /**
     *
     * 
     * 
     * 
     * https://www.facebook.com/business/m/privacy-and-data
     * 
     * https://developers.facebook.com/docs/meta-pixel/reference
     * 
     * https://developers.facebook.com/docs/marketing-api/conversions-api/using-the-api
     * https://developers.facebook.com/docs/marketing-api/conversions-api/parameters
     * https://developers.facebook.com/docs/marketing-api/conversions-api/payload-helper
     * 
     * 
     * 
     * 
     * @todo documentare
     * 
     * @file
     *
     */

    /**
     * 
     * AddToCart
     * 
     * Quando un prodotto viene aggiunto al carrello.
     * 
     * Una persona clicca su un pulsante Aggiungi al carrello.	
     * content_ids, content_name, content_type, contents, currency, value
     * 
     */
    function fbEventAddToCart( $m, $c, $fb, $carrello, $articoli ) {

        if( isset( $fb['pixel']['id'] ) && isset( $fb['pixel']['token'] ) ) {

            $valoreTotale = 0;

            foreach( $articoli as &$articolo ) {
                if( isset( $carrello['articoli'][ $articolo['id_articolo'] ]['prezzo_lordo_unitario'] ) ) {

                    // trovo il prezzo lordo dell'articolo
                    // $articolo['prezzo_lordo_unitario'] = $carrello['articoli'][ $articolo['id_articolo'] ]['prezzo_lordo_unitario'];

                    // incremento il valore totale dell'aggiunta
                    $valoreTotale += $carrello['articoli'][ $articolo['id_articolo'] ]['prezzo_lordo_unitario'] * $articolo['quantita'];

                }
            }

            // dati
            $data = array(
                'access_token' => $fb['pixel']['token'],
                'data' => json_encode(
                    array(
                        array(
                            'event_name' => 'AddToCart',
                            'event_time' => time(),
                            'action_source' => 'website',
                            'event_source_url' => $_SERVER['REDIRECT_URL'],
                            'client_ip_address' => getenv("REMOTE_ADDR"),
                            'client_user_agent' => $_SERVER['HTTP_USER_AGENT'],
                            'user_data' => array(
                                'external_id' => array(
                                    hash( 'sha256', $carrello['id'] )
                                )
                            ),
                            'custom_data' => array(
                                'currency' => 'EUR',
                                'value' => $valoreTotale
                            )
                        )
                    )
                )
            );

            // chiamata
            restCall(
                'https://graph.facebook.com/v15.0/'.$fb['pixel']['id'].'/events',
                METHOD_POST,
                $data,
                MIME_X_WWW_FORM_URLENCODED,
                MIME_APPLICATION_JSON,
                $status,
                array(),
                NULL,
                NULL,
                $error
            );

            // debug
            // echo '<pre>';
            // print_r( $articoli );
            // print_r( $carrello );
            // print_r( $data );
            // print_r( $status );
            // print_r( $error );
            // echo '</pre>';

        }

    }

    /**
     * 
     * Quando viene completato un modulo di registrazione.
     * Una persona invia un modulo di iscrizione o registrazione completato.	
     * content_name, currency, status, value
     * 
     * TODO per il modulo registrazione
     * 
     */
    function fbCompleteRegistration() {

    }

    /**
     * 
     * Contact
     * Quando una persona contatta la tua azienda via telefono, SMS, e-mail, chat ecc.
     * Una persona invia una domanda su un prodotto.
     * 
     * TODO per il modulo contatti
     * 
     */
    function fbContact() {

    }

    /**
     * 
     * 
     * Purchase
     * Quando viene effettuato un acquisto o viene completata la procedura di acquisto.
     * Una persona ha completato la procedura di acquisto e viene visualizzata la pagina di ringraziamento o di conferma.	
     * content_ids, content_name, content_type, contents, currency, num_items, value
     * Obbligatorie:currency e value
     * Obbligatorie per le inserzioni del catalogo Advantage+: content_type e contents o content_ids
     * 
     * 
     * 
     * 
     * 
     */
    function fbPurchase() {

    }

    /**
     * 
     * 
     * Schedule
     * Quando una persona prenota un appuntamento per visitare una delle tue sedi.
     * Una persona seleziona una data e un orario per la lezione di tennis.
     * 
     * 
     * 
     * TODO per il modulo agenda lato pubblico (dove gli utenti prendono gli appuntamenti)
     * 
     * 
     */
    function fbSchedule() {

    }

    /**
     * 
     * 
     * Search
     * Quando viene effettuata una ricerca.
     * Una persona cerca un prodotto sul tuo sito web.	
     * content_category, content_ids, contents, currency, search_string, value
     * 
     * 
     * TODO per il modulo ricerca
     * 
     * 
     * 
     */
    function fbSearch() {

    }

    /**
     * 
     * 
     * ViewContent
     * La visita a una pagina web che ti interessa (ad esempio, una pagina di prodotto o una pagina di destinazione).
     * ViewContent ti dice se un utente visita l'URL di una pagina web, ma non ciò che consulta o le operazioni che svolge sulla pagina.
     * Una persona visita una pagina dei dettagli del prodotto.	
     * content_ids, content_category, content_name, content_type, contents, currency, value
     * 
     * 
     * 
     * TODO questo è interessante, vediamo come usarlo
     * 
     * 
     * 
     */
    function fbViewContent() {

    }

    /**
     * 
     * 
     * 
     * Lead
     * Quando viene completata un'iscrizione.
     * Una persona clicca sui prezzi.	
     * content_category, content_name, currency, value
     * 
     * 
     * TODO sembra utile, vediamo come usarlo
     * 
     * 
     */
    function fbLead() {

    }

    /**
     * 
     * 
     * 
     * Subscribe
     * Quando una persona sottoscrive un abbonamento a pagamento per un prodotto o servizio da te offerto.
     * Una persona attiva l'iscrizione per il tuo servizio di streaming.	
     * currency, predicted_ltv, value
     * 
     * TODO quando uno si abbona alla rivista, eccetera? 
     * 
     * 
     */
    function fbSubscribe() {

    }

    /**
     * 
     * 
     * SubmitApplication
     * Quando una persona richiede un prodotto, un servizio o un programma da te offerto.
     * Una persona invia una richiesta per una carta di credito, per un programma formativo o per un lavoro.	Facoltativa.	
     * 
     * 
     * 
     * TODO per...? 
     * 
     * 
     */
    function fbSubmitApplication() {

    }

    // NOTA eventi scartati
    //
    // AddPaymentInfo
    // Quando vengono aggiunte informazioni di pagamento alla procedura di acquisto.
    // Una persona clicca su un pulsante Salva informazioni di fatturazione.	
    // content_category, content_ids, contents, currency, value
    //
    // AddToWishlist
    // Quando un prodotto viene aggiunto a una lista dei desideri.
    // Una persona clicca su un pulsante Aggiungi alla lista dei desideri.	
    // content_name, content_category, content_ids, contents, currency, value
    // 
    // CustomizeProduct
    // Quando una persona personalizza un prodotto.
    // Una persona seleziona il colore di una t-shirt.
    //
    // Donate
    // Quando una persona dona fondi alla tua organizzazione o causa.
    // Una persona aggiunge al carrello una donazione alla Humane Society.
    //
    // FindLocation
    // Quando una persona cerca la posizione del tuo negozio tramite un sito web o un'app, con l'intenzione di visitarlo.
    // Una persona desidera trovare un prodotto specifico in un negozio locale.
    //
    // InitiateCheckout
    // Quando una persona accede alla procedura di acquisto prima di averla completata.
    // Una persona clicca su un pulsante Acquista.	
    // content_category, content_ids, contents, currency, num_items, value
    //
    // StartTrial
    // Quando una persona inizia una prova gratuita di un prodotto o servizio da te offerto.
    // Una persona sceglie di usufruire di una settimana gratuita del tuo gioco.	
    // currency, predicted_ltv, value
    //
