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
     * carte per test pagamento semplice
     * 
     * CARTE TEST
     * Con le seguenti carte puoi effettuare i test di pagamento:
     * 
     * Circuito	Numero carta	Scadenza	CVV2*	Esito Atteso	Messaggio Errore
     * VISA	4539970000000006 (EUR)	12/2030	***	Pagamento accettato	Message Ok
     * VISA	4539970000000014 (EUR)	12/2030	***	Pagamento rifiutato	Auth. Denied
     * VISA	4539970000101010 (EUR)	12/2030	***	Pagamento rifiutato	expired card
     * VISA	4539970000104014 (EUR)	12/2030	***	Pagamento rifiutato	restricted card
     * VISA	4539970000109013 (EUR)	12/2030	***	Pagamento rifiutato	invalid merchant
     * VISA	4539970000110011 (EUR)	12/2030	***	Pagamento rifiutato	transaction not permitted
     * VISA	4539970000116018 (EUR)	12/2030	***	Pagamento rifiutato	not sufficient funds
     * VISA	4539970000117016 (EUR)	12/2030	***	Pagamento rifiutato	incorret PIN
     * VISA	4539970000118014 (EUR)	12/2030	***	Pagamento rifiutato	no card record
     * VISA	4539970000902011 (EUR)	12/2030	***	Pagamento rifiutato	Technical problem
     * VISA	4539970000907010 (EUR)	12/2030	***	Pagamento rifiutato	Host not found
     * MASTERCARD	5255000000000001 (EUR)	12/2030	***	Pagamento accettato	Message Ok
     * MASTERCARD	5255000000000019 (EUR)	12/2030	***	Pagamento rifiutato	Auth. Denied
     * MASTERCARD	5255000000101015 (EUR)	12/2030	***	Pagamento rifiutato	expired card
     * MASTERCARD	5255000000104019 (EUR)	12/2030	***	Pagamento rifiutato	restricted card
     * MASTERCARD	5255000000109018 (EUR)	12/2030	***	Pagamento rifiutato	invalid merchant
     * MASTERCARD	5255000000110016 (EUR)	12/2030	***	Pagamento rifiutato	transaction not permitted
     * MASTERCARD	5255000000116013 (EUR)	12/2030	***	Pagamento rifiutato	not sufficient funds
     * MASTERCARD	5255000000117011 (EUR)	12/2030	***	Pagamento rifiutato	incorret PIN
     * MASTERCARD	5255000000118019 (EUR)	12/2030	***	Pagamento rifiutato	no card record
     * MASTERCARD	5255000000902016 (EUR)	12/2030	***	Pagamento rifiutato	Technical problem
     * MASTERCARD	5255000000907015 (EUR)	12/2030	***	Pagamento rifiutato	Host not found
     * 
     * * qualsiasi combinazione di 3 numeri è accettata
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
        
        $$params = array(
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
        
        logger( 'richiesta a Nexi per carrello '. $c['id'] . ' (' . $k['init_api'] . ') invio: ' . print_r( $headers, true ), 'nexi' );
        logger( 'richiesta a Nexi per carrello '. $c['id'] . ' (' . $k['init_api'] . ') invio: ' . print_r( $params, true ), 'nexi' );
        
        $ch = curl_init($apiUrl);
        $payload = json_encode($$params);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $resultJson = curl_exec($ch);
        
        if (curl_errno($ch)) {
            // die("curl error: " . curl_error($ch));
            logger( 'errore curl: ' . curl_error($ch), 'nexi', LOG_ERR );
        }
        
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        if ($http_code != 200) {
            // die("invalid http status code: ".print_r($http_code, true));
            logger( 'errore http: ' . print_r($http_code, true), 'nexi', LOG_ERR );
        }
        
        curl_close($ch);
        
        $resultData = json_decode($resultJson);
        
        // echo "Hosted Page: " . $resultData->hostedPage . "\n";
        // echo "Security Token: " . $resultData->securityToken . "\n";

        logger( 'risposta per carrello ' . $c['id'] . ': ' . print_r( $resultData, true ), 'nexi' );

        return array(
            'paymentId' => $resultData->paymentId,
            'hostedPage' => $resultData->hostedPage,
            'securityToken' => $resultData->securityToken,
            'correlationId' => $correlationId,
        );

    }

    function nexiuuidv4() {

        $data = random_bytes(16);
    
        $data[6] = chr(ord($data[6]) & 0x0f | 0x40); // set version to 0100
        $data[8] = chr(ord($data[8]) & 0x3f | 0x80); // set bits 6-7 to 10
        
        return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));

    }