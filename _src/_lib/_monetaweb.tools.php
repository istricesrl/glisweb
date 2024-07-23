<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * logica di funzionamento
     * -----------------------
     * Il funzionamento di Monetaweb è appena più complicato di quello di Nexi o PayPal classico, in pratica quando vado al
     * checkout faccio una chiamata a Monetaweb per ottenere un ID di pagamento e un URL, poi dalla pagina di riepilogo con
     * il classico submit automatico mando l'utente a quell'URL aggiungendo l'ID di pagamento
     * 
     * Per il resto, Monetaweb chiama poi il suo listener come al solito che si occupa materialmente di salvare il pagamento.
     * 
     * 
     * 
     * 
     * 
     * 
     * ambiente di test
     * ----------------
     * Per i pagamenti standard il sistema simula una richiesta di autorizzazione senza verificare la data scadenza e il cvv;
     * l’esito della transazione viene determinato sulla base dell’importo valorizzato:
     * 
     * - se importo = 9999 -> transazione negata
     * - se importo <> 9999 -> transazione autorizzata
     * 
     * Per i pagamenti ricorrenti e per l'utilizzo di MonetaWallet, il sistema effettua una richiesta di autorizzazione in
     * ambiente di test verificando tutti i dati carta.
     * 
     * Il nome titolare carta può essere qualsiasi.
     * 
     * Nell'ottica di garantire una maggiore segregazione tra gli ambienti di TEST e PRODUZIONE, l'ambiente di TEST accetta
     * solo il set di carte di credito sotto riportate. Tutte le altre carte riceveranno l'esito NOT APPROVED con response
     * code 111 – Numero Carta non Valido.
     * 
     * circuito     | numero carta              | data scadenza | CVV   | verifica 3Ds      | password 3Ds      | esito
     * -------------|---------------------------|---------------|-------|-------------------|-------------------|------------
     * VISA         | 4830540099991310          | 01/2016       | 557   | ENROLLED          | valid             | OK
     * VISA         | 4830540099991294          | 01/2016       | 952   | ENROLLED          | valid             | OK
     * VISA         | 4943319600654566          | 02/2016       | 904   | NOT ENROLLED      |                   | OK
     * VISA         | 4943319600664524          | 02/2016       | 714   | NOT ENROLLED      |                   | OK
     * MC           | 5533890199999896          | 02/2018       | 670   | ENROLLED          | valid             | OK
     * MC           | 5398320199991093          | 01/2017       | 295   | ENROLLED          | valid             | OK
     * MC           | 5533890199999870          | 02/2018       | 145   | ENROLLED          | valid             | OK
     * MC           | 5209569603682990          | 02/2016       | 411   | NOT ENROLLED      |                   | OK
     * AMEX         | 375200000000003           | 12/2018       | 5861  | NOT SUPPORTED     |                   | OK
     * DINERS       | 36961903000009            | 11/2018       | 553   | NOT SUPPORTED     |                   | OK
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * TODO nella libreria tools di ogni metodo di pagamento bisognerebbe riportare la spiegazione di come funziona
     * quello specifico metodo di pagamento, questo andrebbe fatto per tutti i metodi
     * 
     */

    /**
     * 
     * 
     * 
     */
    function monetawebGetPaymentDetails( $c, $k ) {

        $url = $k['init_api'] . '?' . http_build_query( array(
            'id'            => $k['term_id'],                                   // ID del terminale
            'password'      => $k['term_passwd'],                               // password del terminale
            'action'        => 4,                                               // richiesta di autorizzazione
            'amt'           => sprintf( '%0.2f', $c['prezzo_lordo_totale'] ),   // totale lordo del carrello
            'currencycode'  => 978,                                             // euro
            'langid'        => 'ITA',                                           // lingua della pagina di pagamento (ITA, USA, SPA, FRA, DEU)
            'responseurl'   => $k['success_url'],                               // URL di ritorno in caso di successo
            'errorurl'      => $k['error_url'],                                 // URL di ritorno in caso di errore
            'trackid'       => $c['id'],                                        // ID del carrello
            'udf1'          => 'pagamento Monetaweb'                            // descrizione del pagamento
        ) );

        $result = restCall(
            $url,
            METHOD_POST,
            array(),
            MIME_X_WWW_FORM_URLENCODED,
            MIME_TEXT_PLAIN,
            $status,
            array(),
            $k['client_id'],
            $k['client_secret'],
            $error
        );

        logger( 'richiesta a Monetaweb per carrello '. $c['id'] . ' (' . $url . ') risposta: ' . print_r( $result, true ), 'monetaweb' );

        $dettagli = explode( ':', $result );

        if( count( $dettagli ) == 2 ) {

            $dettagli[2] = $dettagli[1] . '?PaymentID=' . $dettagli[0];

        }

        return $dettagli;

    }
