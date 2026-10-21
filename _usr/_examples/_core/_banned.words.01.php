<?php

    // imposto l'output
    header( 'Content-type: text/plain' );

    // lettura delle parole proibite
    $words = array_map( 'trim', file( '../../../_etc/_security/_banned.words.conf' ) );

    // URL da chiamare
    $url = "https://glisdev.istricesrl.com/";

    // chiamo l'URL con ognuna delle parole vietate nell'URL
    foreach( $words as $word ) {

        // inizializzo la sessione cURL
        $ch = curl_init( $url . $word );

        // catturo la risposta in una variabile
        curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );

        // eseguo la richiesta cURL e ottengo la risposta
        $response = curl_exec( $ch );

        // ottengo il codice di stato HTTP
        $httpCode = curl_getinfo( $ch, CURLINFO_HTTP_CODE );

        // se una parola passa, esco dal ciclo
        if( $httpCode == 200 ) {
            die( 'test URL fallito' . PHP_EOL );
        }

        // chiudo la sessione cURL
        curl_close( $ch );

    }

    // risultato finale
    echo 'test URL passato' . PHP_EOL;

    // chiamo l'URL con ognuna delle parole vietate nella $_REQUEST
    foreach( $words as $word ) {

        // inizializzo la sessione cURL
        $ch = curl_init( $url );

        // catturo la risposta in una variabile
        curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );

        // imposto la chiamata come POST
        curl_setopt( $ch, CURLOPT_POST, true );

        // imposto il contenuto della $_REQUEST
        curl_setopt( $ch, CURLOPT_POSTFIELDS, array( 'chiave' => $word ) );

        // eseguo la richiesta cURL e ottengo la risposta
        $response = curl_exec( $ch );

        // ottengo il codice di stato HTTP
        $httpCode = curl_getinfo( $ch, CURLINFO_HTTP_CODE );

        // se una parola passa, esco dal ciclo
        if( $httpCode == 200 ) {
            die( 'test $_REQUEST fallito' . PHP_EOL );
        }

        // chiudo la sessione cURL
        curl_close( $ch );

    }

    // risultato finale
    echo 'test $_REQUEST passato' . PHP_EOL;
