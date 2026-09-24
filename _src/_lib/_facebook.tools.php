<?php

    /**
     * libreria per l'integrazione con Facebook
     * 
     * Questa libreria contiene le funzioni per inviare a Facebook gli eventi di conversione del sito tramite la Conversions API
     * e per leggere i dati delle pagine Facebook tramite la Graph API.
     * 
     * introduzione
     * ============
     * La Conversions API permette di comunicare a Facebook, lato server, gli eventi che il pixel di Meta rileverebbe nel browser
     * ( aggiunte al carrello, acquisti, registrazioni... ), in modo che le campagne pubblicitarie possano misurare le conversioni
     * anche quando il pixel viene bloccato; ID e token del pixel si leggono dal profilo Facebook corrente,
     * $cf['facebook']['profile'], dichiarato al runlevel _src/_config/_645.facebook.php. Per ora è implementato solo l'evento
     * AddToCart: le altre funzioni sono segnaposto vuoti che riportano la descrizione dell'evento secondo Facebook e i
     * custom_data previsti, e gli eventi che non interessano sono elencati in una nota in fondo al gruppo.
     * 
     * La Graph API serve invece per leggere i dati delle pagine, per ora le recensioni; per accedervi serve il token di accesso
     * della pagina, che si ricava una volta sola con getFbPageAccessToken() e si salva nella configurazione.
     * 
     * Riferimenti utili:
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
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni per la Conversions API
     * -------------------------------
     * Le funzioni in questo gruppo servono per inviare a Facebook gli eventi di conversione.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * fbEventAddToCart()               | notifica a Facebook l'aggiunta di articoli al carrello
     * fbCompleteRegistration()         | segnaposto per l'evento CompleteRegistration
     * fbContact()                      | segnaposto per l'evento Contact
     * fbPurchase()                     | segnaposto per l'evento Purchase
     * fbSchedule()                     | segnaposto per l'evento Schedule
     * fbSearch()                       | segnaposto per l'evento Search
     * fbViewContent()                  | segnaposto per l'evento ViewContent
     * fbLead()                         | segnaposto per l'evento Lead
     * fbSubscribe()                    | segnaposto per l'evento Subscribe
     * fbSubmitApplication()            | segnaposto per l'evento SubmitApplication
     * 
     * funzioni per la Graph API
     * -------------------------
     * Le funzioni in questo gruppo servono per leggere i dati delle pagine Facebook.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * getFbPageAccessToken()           | legge ID e access_token per le pagine a partire da un token di accesso utente di breve durata
     * getFbPageReviews()               | legge le recensioni di una pagina
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * restCall()                       | _src/_lib/_rest.tools.php
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     * @file
     *
     */

    /**
     * FUNZIONI PER LA CONVERSIONS API
     */

    /**
     * notifica a Facebook l'aggiunta di articoli al carrello
     * 
     * Questa funzione invia alla Conversions API l'evento AddToCart, che per Facebook scatta quando un prodotto viene aggiunto
     * al carrello ( una persona clicca su un pulsante Aggiungi al carrello ). La chiama il controller del carrello del modulo
     * ecommerce ( _mod/_4170.ecommerce/_src/_config/_750.controller.php ) passandole gli articoli appena aggiunti.
     * 
     * Il valore dell'evento è la somma, per ogni articolo aggiunto, del prezzo lordo unitario che l'articolo ha nel carrello per
     * la quantità aggiunta; gli articoli che nel carrello non hanno un prezzo non contribuiscono. La valuta è sempre EUR,
     * l'utente viene identificato dall'hash SHA-256 dell'ID del carrello, e fra i custom_data previsti da Facebook ( content_ids,
     * content_name, content_type, contents, currency, value ) vengono inviati solo currency e value. Se nel profilo non sono
     * configurati ID e token del pixel la funzione non fa niente; l'esito della chiamata non viene né controllato né loggato.
     * 
     * TODO event_source_url riceve solo il percorso della richiesta ( REDIRECT_URL o REQUEST_URI ), mentre la Conversions API
     * vuole l'URL completo con il protocollo e l'host, come quello composto nella riga di debug commentata.
     * 
     * @param       object      $m          la connessione a Memcached ( non utilizzata )
     * @param       object      $c          la connessione al database ( non utilizzata )
     * @param       array       $fb         il profilo Facebook corrente, $cf['facebook']['profile'], con le chiavi pixel/id e pixel/token
     * @param       array       $carrello   il carrello in sessione, con le chiavi id e articoli
     * @param       array       $articoli   gli articoli aggiunti, ciascuno con le chiavi id_articolo e quantita
     * 
     * @return      void
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
     * segnaposto per l'evento CompleteRegistration
     * 
     * Questa funzione è vuota. L'evento CompleteRegistration scatta quando viene completato un modulo di registrazione:
     * una persona invia un modulo di iscrizione o registrazione completato.
     * custom_data: content_name, currency, status, value
     * 
     * TODO per il modulo registrazione
     * 
     * @return      void
     * 
     */
    function fbCompleteRegistration() {

    }

    /**
     * segnaposto per l'evento Contact
     * 
     * Questa funzione è vuota. L'evento Contact scatta quando una persona contatta la tua azienda via telefono, SMS, e-mail,
     * chat ecc.: una persona invia una domanda su un prodotto.
     * 
     * TODO per il modulo contatti
     * 
     * @return      void
     * 
     */
    function fbContact() {

    }

    /**
     * segnaposto per l'evento Purchase
     * 
     * Questa funzione è vuota. L'evento Purchase scatta quando viene effettuato un acquisto o viene completata la procedura di
     * acquisto: una persona ha completato la procedura di acquisto e viene visualizzata la pagina di ringraziamento o di conferma.
     * custom_data: content_ids, content_name, content_type, contents, currency, num_items, value
     * Obbligatorie: currency e value
     * Obbligatorie per le inserzioni del catalogo Advantage+: content_type e contents o content_ids
     * 
     * NOTA al checkout ( _mod/_4170.ecommerce/_src/_inc/_controllers/_checkout.finally.success.php ) la conversione Facebook è
     * ancora un TODO; la conversione GA4 corrispondente è ga4purchase() in _src/_lib/_analytics.tools.php.
     * 
     * @return      void
     * 
     */
    function fbPurchase() {

    }

    /**
     * segnaposto per l'evento Schedule
     * 
     * Questa funzione è vuota. L'evento Schedule scatta quando una persona prenota un appuntamento per visitare una delle tue
     * sedi: una persona seleziona una data e un orario per la lezione di tennis.
     * 
     * TODO per il modulo agenda lato pubblico (dove gli utenti prendono gli appuntamenti)
     * 
     * @return      void
     * 
     */
    function fbSchedule() {

    }

    /**
     * segnaposto per l'evento Search
     * 
     * Questa funzione è vuota. L'evento Search scatta quando viene effettuata una ricerca: una persona cerca un prodotto sul
     * tuo sito web.
     * custom_data: content_category, content_ids, contents, currency, search_string, value
     * 
     * TODO per il modulo ricerca
     * 
     * @return      void
     * 
     */
    function fbSearch() {

    }

    /**
     * segnaposto per l'evento ViewContent
     * 
     * Questa funzione è vuota. L'evento ViewContent è la visita a una pagina web che ti interessa (ad esempio, una pagina di
     * prodotto o una pagina di destinazione): ti dice se un utente visita l'URL di una pagina web, ma non ciò che consulta o le
     * operazioni che svolge sulla pagina. Una persona visita una pagina dei dettagli del prodotto.
     * custom_data: content_ids, content_category, content_name, content_type, contents, currency, value
     * 
     * TODO questo è interessante, vediamo come usarlo
     * 
     * @return      void
     * 
     */
    function fbViewContent() {

    }

    /**
     * segnaposto per l'evento Lead
     * 
     * Questa funzione è vuota. L'evento Lead scatta quando viene completata un'iscrizione: una persona clicca sui prezzi.
     * custom_data: content_category, content_name, currency, value
     * 
     * TODO sembra utile, vediamo come usarlo
     * 
     * @return      void
     * 
     */
    function fbLead() {

    }

    /**
     * segnaposto per l'evento Subscribe
     * 
     * Questa funzione è vuota. L'evento Subscribe scatta quando una persona sottoscrive un abbonamento a pagamento per un
     * prodotto o servizio da te offerto: una persona attiva l'iscrizione per il tuo servizio di streaming.
     * custom_data: currency, predicted_ltv, value
     * 
     * TODO quando uno si abbona alla rivista, eccetera? 
     * 
     * @return      void
     * 
     */
    function fbSubscribe() {

    }

    /**
     * segnaposto per l'evento SubmitApplication
     * 
     * Questa funzione è vuota. L'evento SubmitApplication scatta quando una persona richiede un prodotto, un servizio o un
     * programma da te offerto: una persona invia una richiesta per una carta di credito, per un programma formativo o per un
     * lavoro. Facoltativa.
     * 
     * TODO per...? 
     * 
     * @return      void
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
     * FUNZIONI PER LA GRAPH API
     */

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
     * 
     * Questa funzione va chiamata una volta sola e i dati che genera vanno inseriti nel JSON di configurazione. Scambia il
     * token utente di breve durata con uno di lunga durata, ricava l'ID dell'utente e legge l'elenco delle pagine che l'utente
     * gestisce, restituendo il token di accesso della prima; stampa con print_r() la risposta di ciascuna delle tre chiamate,
     * per cui è pensata per essere lanciata a mano e non da una pagina. Non ha chiamanti nel framework.
     * 
     * Gli errori delle chiamate non vengono controllati: se una fallisce le successive partono con dati mancanti e la funzione
     * restituisce NULL, con i relativi warning.
     * 
     * @param       string      $tk         il token di accesso utente di breve durata, generato in https://developers.facebook.com/tools/explorer/
     * @param       array       $app        l'app di appoggio, con le chiavi id e secret ( client_id e client_secret )
     * 
     * @return      string                  il token di accesso della prima pagina dell'utente
     * 
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
     * 
     * Questa funzione legge dalla Graph API le recensioni di una pagina Facebook
     * ( https://developers.facebook.com/docs/graph-api/reference/v2.2/page/ratings ) e restituisce la risposta decodificata
     * così com'è, senza controllarne l'esito. Per accedere alle recensioni è necessario aver inserito nella configurazione l'ID e
     * l'access_token della pagina ricavati da getFbPageAccessToken(). Non ha chiamanti nel framework.
     * 
     * @param       array       $pg         la pagina, con le chiavi id e token
     * 
     * @return      mixed                   la risposta della Graph API, con le recensioni nella chiave data
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


