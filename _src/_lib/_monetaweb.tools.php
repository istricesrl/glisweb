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
     * Queste carte sono testate nel 2025:
     * 
     * CIRCUITO	NUMERO CARTA	DATA SCADENZA	CVV	VERIFICA 3D SECURE	CODICE PIN/OTP SMS
     * VISA	4349942499990906	12/30	034	ENROLLED	ok
     * MC	5398322499900998	12/30	234	ENROLLED	ok
     * 
     * vedi https://developer.nexi.it/it/Area-di-Test/Carte-di-Credito
     * vedi https://developer.nexi.it/it/Area-di-Test/area-test
     * vedi https://developer.nexi.it/it/gateway-di-pagamento-e-commerce/specifiche-di-utilizzo-del-servizio
     * 
     * Url di produzione	https://xpay.nexigroup.com/monetaweb/payment/2/xml
     * Url di test	https://stg-ta.nexigroup.com/monetaweb/payment/2/xml
     * 
     * 
     * TODO nella libreria tools di ogni metodo di pagamento bisognerebbe riportare la spiegazione di come funziona
     * quello specifico metodo di pagamento, questo andrebbe fatto per tutti i metodi
     * 
     */

    /**
     * chiede a Monetaweb il PaymentID e l'URL della pagina di pagamento ospitata
     * 
     * La funzione fa la POST initialize all'endpoint init_api del profilo con le credenziali del terminale, l'ID del
     * carrello come merchantOrderId e il suo prezzo_lordo_finale come importo. Il certificato del server viene
     * verificato, a meno che il deploy non abbia definito la costante MONETAWEB_SSL_VERIFY a false ( si veda il
     * commento nel corpo ). Gli URL error_url e listener_url devono essere già stati scritti in $k dal chiamante.
     * 
     * @param       array       $c          il carrello ( servono id e prezzo_lordo_finale )
     * @param       array       $k          il profilo del provider monetaweb, con gli URL di ritorno già risolti
     * 
     * @return      array                   response ( hostedpageurl, paymentid, securitytoken ) e redirecturl, oppure un
     *                                      array vuoto se il gateway non ha restituito paymentid e hostedpageurl
     * 
     */
    function monetawebGetPaymentDetails( $c, $k ) {

        
    /*        
        $merchantDomain = 'http://127.0.0.1';
        $PaymentGatewayDomain = 'https://ngwecomm-stg.nexi.it';
        $terminalId = '44000001';
        $terminalPassword = 'Password1';
        $tenantId = '10';
        
          $params = array(
              'id' => $terminalId,
              'password' => $terminalPassword,
                  'tenantId' => $tenantId, // Nel caso in cui si tratti di un esercente convenzionato con Intesa inserire "10", altrimenti inserire "20"
              'operationType' => 'initialize',
              'amount' => '1.00',	  
              'language' => 'ITA',
              'responseToMerchantUrl' => $merchantDomain.'/notify.php',
                  'merchantOrderId' => 'TRCK0001',
                  'currencyCode' => '978',
              'recoveryUrl' => $merchantDomain.'/recovery.php',
                  'description' => 'Descrizione',
                  'cardHolderName' => 'Tom Smith',
                  'cardHolderEmail'  => 'tom.smith@test.com',
                  'customField' => 'Custom Field'
          );
*/
          $params = array(
            'id'            => $k['term_id'],                                   // ID del terminale
            'password'      => $k['term_passwd'],                               // password del terminale
            'tenantId'      => $k['merchant_id'],                                 // tenant ID
            // 'action'        => 4,                                               // richiesta di autorizzazione
            'operationType' => 'initialize',                                    // tipo di operazione
            // 'amt'           => str_replace( ',', '.', sprintf( '%0.2f', $c['prezzo_lordo_totale'] ) ),   // totale lordo del carrello
        
            // SDF 13-12-2024 sostituito prezzo_lordo_totale con prezzo_lordo_finale altrimenti se ci sono sconti si manda al pagamento del prezzo non scontato
        #    'amount'        => str_replace( ',', '.', sprintf( '%0.2f', $c['prezzo_lordo_totale'] ) ),   // totale lordo del carrello
            'amount'        => str_replace( ',', '.', sprintf( '%0.2f', $c['prezzo_lordo_finale'] ) ),   // totale lordo del carrello
        
            'currencycode'  => 978,                                             // euro
            // 'langid'        => 'ITA',                                           // lingua della pagina di pagamento (ITA, USA, SPA, FRA, DEU)
            'language'      => 'ITA',                                           // lingua della pagina di pagamento (ITA, USA, SPA, FRA, DEU, RUS)
            // 'responseurl'   => $k['success_url'],                               // URL di ritorno in caso di successo
            // 'errorurl'      => $k['error_url'],                                 // URL di ritorno in caso di errore
             'recoveryUrl'      => $k['error_url'],                                 // URL di ritorno in caso di errore
            // 'responseTomerchantUrl' => $k['success_url'],                       // URL di ritorno in caso di successo
            'responseTomerchantUrl' => $k['listener_url'],                       // URL di ritorno in caso di successo
            //'recoveryUrl'   => $k['error_url'],                                 // URL di ritorno in caso di errore
            // 'trackid'       => $c['id'],                                        // ID del carrello
            'merchantOrderId' => $c['id'],                                      // ID del carrello
            // 'udf1'          => 'pagamento Monetaweb'                            // descrizione del pagamento
        );


          // verifica del certificato del server
          //
          // Fino al 2026-09-29 CURLOPT_SSL_VERIFYPEER era a false, per cui la chiamata che manda ID e password del
          // terminale non proteggeva da un server che si spacciasse per il gateway. Adesso il certificato si verifica
          // sempre, e il deploy che ha bisogno di non farlo ( ad esempio contro un ambiente di test del gateway con un
          // certificato non valido ) lo dice esplicitamente definendo in un runlevel la costante MONETAWEB_SSL_VERIFY
          // a false. È lo stesso schema di REST_SSL_VERIFY in restCall(), per cui si vedano i commenti in
          // _src/_lib/_rest.tools.php; come lì, la costante si legge a ogni chiamata perché le librerie vengono
          // incluse prima dei runlevel.
          $sslVerify = defined( 'MONETAWEB_SSL_VERIFY' ) ? (bool) MONETAWEB_SSL_VERIFY : true;

          $ch = curl_init();
          curl_setopt($ch, CURLOPT_URL, $k['init_api']);
          curl_setopt( $ch, CURLOPT_SSL_VERIFYPEER, $sslVerify );
          curl_setopt( $ch, CURLOPT_SSL_VERIFYHOST, ( $sslVerify ) ? 2 : 0 );
          curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
          curl_setopt($ch, CURLOPT_POST, true);
          curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($params));
          $result = curl_exec($ch);

          // con la verifica accesa un certificato non valido fa fallire la chiamata: lo scrivo nel log
          if( curl_errno( $ch ) ) {
              logger( 'errore curl per carrello ' . $c['id'] . ': ' . curl_error( $ch ), 'monetaweb', LOG_ERR );
          }

          curl_close($ch);

//          $response = new SimpleXMLElement($xmlResponse);
//          $paymentId = $response->paymentid;
//          $paymentUrl = $response->hostedpageurl;
//          $securityToken = $response->securitytoken;
//          $PaymentPageUrl = "$paymentUrl?PaymentID=$paymentId";

$dettagli = xml2array( $result, false );

            // logger( 'richiesta a Monetaweb per carrello '. $c['id'] . ' (' . $k['init_api'] . ') risposta: ' . $result, 'monetaweb' );
            logger( 'richiesta a Monetaweb per carrello '. $c['id'] . ' (' . $k['init_api'] . ') risposta: ' . print_r( $dettagli, true ), 'monetaweb' );


          // valore di ritorno, vuoto se il gateway non ha restituito paymentid e hostedpageurl ( i chiamanti
          // controllano redirecturl )
          $info = array();

          if( ! empty( $dettagli['response']['paymentid']['#'] ) && ! empty( $dettagli['response']['hostedpageurl']['#'] ) ) {

            $info['response']['hostedpageurl'] = $dettagli['response']['hostedpageurl']['#'];
            $info['response']['paymentid'] = $dettagli['response']['paymentid']['#'];
            $info['response']['securitytoken'] = $dettagli['response']['securitytoken']['#'];

            // $dettagli[3] = $dettagli[1] . ':' . $dettagli[2] . '?PaymentID=' . $dettagli[0];
            $info['redirecturl'] = $dettagli['response']['hostedpageurl']['#'] . '?PaymentID=' . $dettagli['response']['paymentid']['#'];

        }

        return $info;
          
    }
