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
     * 
     * helper per comporre e testare le chiamate
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
     * custom_data: content_ids, content_name, content_type, contents, currency, value
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

            // debug
            // die( 'http' . ( isset( $_SERVER['HTTPS'] ) ? 's' : '' ) . '://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'] );

            // dati
            $data = array(
                'access_token' => $fb['pixel']['token'],
                'data' => json_encode(
                    array(
                        array(
                            'event_name' => 'AddToCart',
                            'event_time' => time(),
                            'action_source' => 'website',
                            'event_source_url' => ( ( isset( $_SERVER['REDIRECT_URL'] ) ) ? $_SERVER['REDIRECT_URL'] : $_SERVER['REQUEST_URI'] ),
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
     * custom_data: content_name, currency, status, value
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
     * custom_data: content_ids, content_name, content_type, contents, currency, num_items, value
     * Obbligatorie: currency e value
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
     * custom_data: content_category, content_ids, contents, currency, search_string, value
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
     * custom_data: content_ids, content_category, content_name, content_type, contents, currency, value
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
     * custom_data: content_category, content_name, currency, value
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
     * custom_data: currency, predicted_ltv, value
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
     * Una persona invia una richiesta per una carta di credito, per un programma formativo o per un lavoro. Facoltativa.	
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
    // custom_data: content_category, content_ids, contents, currency, value
    //
    // AddToWishlist
    // Quando un prodotto viene aggiunto a una lista dei desideri.
    // Una persona clicca su un pulsante Aggiungi alla lista dei desideri.	
    // custom_data: content_name, content_category, content_ids, contents, currency, value
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
    // custom_data: content_category, content_ids, contents, currency, num_items, value
    //
    // StartTrial
    // Quando una persona inizia una prova gratuita di un prodotto o servizio da te offerto.
    // Una persona sceglie di usufruire di una settimana gratuita del tuo gioco.	
    // custom_data: currency, predicted_ltv, value
    //

    /**
     * introduzione a Open Graph
     * https://developers.facebook.com/docs/graph-api/
     * 
     * guida ai token d'accesso
     * https://developers.facebook.com/docs/facebook-login/guides/access-tokens
     * 
     * tool di esplorazione delle API Graph
     * https://developers.facebook.com/tools/explorer
     * 
     * creazione di un'app di appoggio che deve avere le autorizzazioni pages_show_list e pages_read_user_content
     * https://developers.facebook.com/apps/
     * 
     */

    /**
     * legge ID e access_token per le pagine a partire da un token di accesso utente di breve durata
     * questa funzione va chiamata una volta sola e i dati che genera vanno inseriti nel JSON di configurazione
     */
    function getFbPageAccessToken( $tk, $app ) {


        // ottenere un token di accesso utente di lunga data partendo da un token di accesso utente di breve durata
        // NOTA client_id e client_secret vengono dalla pagina di gestione dell'app https://developers.facebook.com/apps/ e vanno salvati nel JSON
        // NOTA fb_exchange_token va generato in https://developers.facebook.com/tools/explorer/ e non va salvato nel JSON
        $res1 = restCall(
            'https://graph.facebook.com/oauth/access_token',
            METHOD_GET,
            array(
                'grant_type' => 'fb_exchange_token',
                'client_id' => $app['id'],
                'client_secret' => $app['secret'],
                'fb_exchange_token' => $tk
            ),
            'query',
            MIME_APPLICATION_JSON,
            $status,
            array(),
            NULL,
            NULL,
            $error
        );

        print_r( $res1 );

        // NOTA da questa chiamata ricavo 

        /* ottenere l'app-scoped-user-ID */
        $res2 = restCall(
            'https://graph.facebook.com/v16.0/me',
            METHOD_GET,
            array(
                'fields' => 'token_for_business',
                'access_token' => $res1['access_token']
            ),
            'query',
            MIME_APPLICATION_JSON,
            $status,
            array(),
            NULL,
            NULL,
            $error
        );

        print_r( $res2 );

        $res3 = restCall(
            'https://graph.facebook.com/v16.0/'.$res2['id'].'/accounts',
            METHOD_GET,
            array(
                'access_token' => $res1['access_token']
            ),
            'query',
            MIME_APPLICATION_JSON,
            $status,
            array(),
            NULL,
            NULL,
            $error
        );

        print_r( $res3 );

        // TODO non è detto che la pagina desiderata sia sempre la numero zero, trovare un modo di far
        // scegliere all'utente quale pagina vuole
        return $res3['data'][0]['access_token'];

    }

    /**
     * legge le recensioni di una pagina
     * https://developers.facebook.com/docs/graph-api/reference/v2.2/page/ratings
     * 
     * per accedere alle recensioni è necessario aver inserito nella configurazione l'ID e l'access_token della pagina
     * ricavati da getFbPageAccessToken()
     * 
     */
    function getFbPageReviews( $pg ) {

        $result = array();

        // chiamata
        $result = restCall(
            'https://graph.facebook.com/v16.0/'.$pg['id'].'/ratings',
            METHOD_GET,
            array(
                'access_token' => $pg['token']
            ),
            'query',
            MIME_APPLICATION_JSON,
            $status,
            array(),
            NULL,
            NULL,
            $error
        );

        // var_dump( $error );
        // print_r( $result );

        return $result;

    }


