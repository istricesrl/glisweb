<?php

    function paypalAdvancedGetAccessToken( $k ) {

        // TODO ottengo l'Access Token
        // curl -v -X POST "https://api-m.sandbox.paypal.com/v1/oauth2/token" -u "<CLIENT_ID>:<CLIENT_SECRET>" -H "Content-Type: application/x-www-form-urlencoded"-d "grant_type=client_credentials"
        $result = restCall(
            'https://api-m.sandbox.paypal.com/v1/oauth2/token',
            METHOD_POST,
            array( 'grant_type' => 'client_credentials' ),
            MIME_X_WWW_FORM_URLENCODED,
            MIME_APPLICATION_JSON,
            $status,
            array(),
            $k['client_id'],
            $k['client_secret'],
            $error
        );

    // debug
        // die( print_r( $result, true ) );
        // die( print_r( $error, true ) );

    // recupero l'access token o l'errore
        if( isset( $result['access_token'] ) ) {

            return $result['access_token'];

        } else {

            logWrite( 'errore nella generazione dell\'access token: ' . print_r( $result, true ), 'paypal', LOG_ERR );

            return NULL;

        }

    }

    function paypalAdvancedGetClientToken( $k ) {

        $tk = paypalAdvancedGetAccessToken( $k );

        // TODO ottengo il Client Token
        // curl -X POST https://api-m.sandbox.paypal.com/v1/identity/generate-token -H 'Content-Type: application/json' -H 'Authorization: Bearer <ACCESS-TOKEN>' -H 'Accept-Language: en_US' 
        $result = restCall(
            $k['token_api'],
            METHOD_POST,
            NULL,
            MIME_APPLICATION_JSON,
            MIME_APPLICATION_JSON,
            $status,
            array(),
            NULL,
            NULL,
            $error,
            $tk
        );

    // recupero il client token o l'errore
        if( isset( $result['client_token'] ) ) {

            return $result['client_token'];

        } else {

            logWrite( 'errore nella generazione del client token: ' . print_r( $result, true ), 'paypal', LOG_ERR );

            return NULL;

        }

    }
