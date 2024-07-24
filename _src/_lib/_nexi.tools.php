<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * logica di funzionamento
     * -----------------------
     * 
     * 
     * 
     * 
     * 
     * 
     * ambiente di test
     * ----------------
     * 
     * 
     * Carte di pagamento
     * Di seguito le carte utilizzabili per eseguire i pagamenti in area di test.
     * 
     * 
     * Esito positivo:
     * CIRCUITO	NUMERO CARTA	DATA SCADENZA	CVV	SCA-3DSECURE
     * VISA	4999340261977289	12/30	663	
     * X
     * VISA	4349940199004549	05/26	396	
     * ✓
     * VISA	4513532658051267	12/30	729	
     * X
     * MASTERCARD	5593497948332903	12/30	399	
     * X
     * MASTERCARD	5472886984585836	12/30	125	
     * ✓
     * 
     * Esito negativo:
     * CIRCUITO	NUMERO CARTA	DATA SCADENZA	CVV	SCA-3DSECURE	OPERATIONRESULT
     * VISA	4349940199997007	12/28	829	
     * X
     * THREEDS_FAILED
     * VISA	4742158750987704	12/30	861	
     * X
     * THREEDS_FAILED
     * MASTERCARD	5515931855858729	12/30	015	
     * X
     * DECLINED
     * MASTERCARD	5311082291191543	12/30	555	
     * X
     * THREEDS_FAILED
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
    function nexiGetSecurityKey( $c, $k ) {

        $apiUrl = $k['init_api'];
        $apiKey = $k['api_key'];
        $orderId = $c['id'];
        
        $requestBodyData = array(
            "order" => array(
                "orderId" => $orderId,
                "amount" => 10,
                "currency" => "EUR",
            ),
            "paymentSession" => array(
                "actionType" => "PAY",
                "amount" => 10,
                "recurrence" => array(
                  "action" => "NO_RECURRING",
                ),
                "language" => "ITA",
                'resultUrl' => $k['success_url'],
                'cancelUrl' => $k['error_url'],
                'notificationUrl' => $k['listener_url'],
            ),
        );
        
        $rawCorrelationId = bin2hex(openssl_random_pseudo_bytes(16));
        
        $correlationId =  substr($rawCorrelationId, 0, 8);
        $correlationId .= "-";
        $correlationId .=  substr($rawCorrelationId, 8, 4);
        $correlationId .= "-";
        $correlationId .=  substr($rawCorrelationId, 12, 4);
        $correlationId .= "-";
        $correlationId .=  substr($rawCorrelationId, 16, 4);
        $correlationId .= "-";
        $correlationId .=  substr($rawCorrelationId, 20);
        
        $headers = array(
            "X-Api-Key: " . $apiKey,
            "Content-Type: application/json",
            "Correlation-Id: " . $correlationId,
        );
        
        $ch = curl_init($apiUrl);
        $payload = json_encode($requestBodyData);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $resultJson = curl_exec($ch);
        
        if (curl_errno($ch)) {
            die("curl error: " . curl_error($ch));
        }
        
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        if ($http_code != 200) {
            die("invalid http status code: ".print_r($http_code, true));
        }
        
        curl_close($ch);
        
        $resultData = json_decode($resultJson);
        
        // echo "Hosted Page: " . $resultData->hostedPage . "\n";
        // echo "Security Token: " . $resultData->securityToken . "\n";

        return array(
            'paymentId' => $resultData->paymentId,
            'hostedPage' => $resultData->hostedPage,
            'securityToken' => $resultData->securityToken,
            'correlationId' => $correlationId,
        );

    }

    function oldNexiGetSecurityKey( $c, $k ) {
//        $url = $k['init_api'] . '?' . http_build_query( array(
        $params = array( "order" => array(
            // 'id'            => $k['term_id'],                                   // ID del terminale
            // 'password'      => $k['term_passwd'],                               // password del terminale
            // 'action'        => 4,                                               // richiesta di autorizzazione
            // 'operationType' => 'initialize',                                    // tipo di operazione
            'amount'           => str_replace( array( ',', '.' ) , '', sprintf( '%0.2f', $c['prezzo_lordo_totale'] ) ),   // totale lordo del carrello
            // 'amount'        => str_replace( ',', '.', sprintf( '%0.2f', $c['prezzo_lordo_totale'] ) ),   // totale lordo del carrello
            'currency'  => 'EUR',                                             // euro
            // 'langid'        => 'ITA',                                           // lingua della pagina di pagamento (ITA, USA, SPA, FRA, DEU)
            // 'language'      => 'ITA',                                           // lingua della pagina di pagamento (ITA, USA, SPA, FRA, DEU, RUS)
            // 'responseurl'   => $k['success_url'],                               // URL di ritorno in caso di successo
            // 'errorurl'      => $k['error_url'],                                 // URL di ritorno in caso di errore
            // 'responseTomerchantUrl' => $k['success_url'],                       // URL di ritorno in caso di successo
            // 'responseTomerchantUrl' => $k['listener_url'],                       // URL di ritorno in caso di successo
            //'recoveryUrl'   => $k['error_url'],                                 // URL di ritorno in caso di errore
            'orderid'       => $c['id'],                                        // ID del carrello
            // 'merchantOrderId' => $c['id'],                                      // ID del carrello
            // 'udf1'          => 'pagamento Monetaweb'                            // descrizione del pagamento
        ),
        "paymentSession" => array(
'actionType' => 'PAY',
'amount' => str_replace( array( ',', '.' ) , '', sprintf( '%0.2f', $c['prezzo_lordo_totale'] ) ),
'language' => 'ITA',
'resultUrl' => $k['success_url'],
'cancelUrl' => $k['error_url'],
'notificationUrl' => $k['listener_url'],
        )
    );
//        ) );

$headers = array(
    'Content-Type: application/json',
    'X-Api-Key: ' . $k['api_key'],
    'Correlation-Id: '.nexiuuidv4(),
    'Content-Length' => strlen( json_encode($params) )
);


logger( 'richiesta a Nexi per carrello '. $c['id'] . ' (' . $k['init_api'] . ') invio: ' . print_r( $headers, true ), 'nexi' );
logger( 'richiesta a Nexi per carrello '. $c['id'] . ' (' . $k['init_api'] . ') invio: ' . print_r( $params, true ), 'nexi' );

        /*
        $result = restCall(
            $url,
            METHOD_POST,
            array(),
            MIME_X_WWW_FORM_URLENCODED,
            // MIME_APPLICATION_XML,
            MIME_TEXT_PLAIN,
            $status,
            // array(),
            // $k['client_id'],
            // $k['client_secret'],
            // $error
        );
        */

        $ch = curl_init();

        curl_setopt($ch, CURLOPT_URL, $k['init_api']);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($params));

        // curl_setopt($ch, CURLOPT_SSL_CIPHER_LIST, 'TLSv1');

        $result = curl_exec($ch);

        curl_close($ch);

        logger( 'richiesta a Nexi per carrello '. $c['id'] . ' (' . $k['init_api'] . ') risposta: ' . $result, 'nexi' );

        // print_r( $params );
        // die( 'risposta: ' . $result );

/*
        $response = new SimpleXMLElement( $xmlResponse );
        $paymentId = $response->paymentid;
        $paymentUrl = $response->hostedpageurl;
        $securityToken = $response->securitytoken;
      
        logger( 'richiesta a Monetaweb per carrello '. $c['id'] . ' (' . $url . ') risposta: ' . print_r( $result, true ), 'monetaweb' );
*/

        $dettagli = explode( ':', $result );

        /*
        <response>
              <paymentid>123456789012345678</paymentid>
              <securitytoken>80957febda6a467c82d34da0e0673a6e</securitytoken>
              <hostedpageurl>https://www.monetaonline.it/monetaweb/...</hostedpageurl>
        </response>
        */

        // $dettagli = xml2array( $result, false );

        if( count( $dettagli ) == 3 ) {
        // if( ! empty( $dettagli['response']['paymentid'] ) && ! empty( $dettagli['response']['hostedpageurl'] ) ) {

            $dettagli[3] = $dettagli[1] . ':' . $dettagli[2] . '?PaymentID=' . $dettagli[0];
            // $dettagli['redirecturl'] = $dettagli['response']['hostedpageurl'] . '?PaymentID=' . $dettagli['response']['paymentid'];

        }

        return $dettagli;

    }

    function nexiuuidv4()
    {
      $data = random_bytes(16);
    
      $data[6] = chr(ord($data[6]) & 0x0f | 0x40); // set version to 0100
      $data[8] = chr(ord($data[8]) & 0x3f | 0x80); // set bits 6-7 to 10
        
      return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
    }