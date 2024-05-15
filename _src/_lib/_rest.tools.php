<?php

    /**
     * libreria di strumenti REST
     *
     *
     *
     * TODO documentare
     *
     *
     *
     */

    // azioni
    if( ! defined( 'METHOD_DELETE' ) )          { define( 'METHOD_DELETE',          'DELETE' ); }
    if( ! defined( 'METHOD_GET' ) )             { define( 'METHOD_GET',             'GET' ); }
    if( ! defined( 'METHOD_PATCH' ) ) {     define( 'METHOD_PATCH'            , 'PATCH' ); }
    if( ! defined( 'METHOD_POST' ) ) {         define( 'METHOD_POST'            , 'POST' ); }
    if( ! defined( 'METHOD_PUT' ) ) {         define( 'METHOD_PUT'            , 'PUT' );  }
    if( ! defined( 'METHOD_REPLACE' ) ) {     define( 'METHOD_REPLACE'        , 'REPLACE' ); }
    if( ! defined( 'METHOD_UPDATE' ) ) {     define( 'METHOD_UPDATE'            , 'UPDATE' ); }

    // costanti per il contenuto
    if( ! defined( 'MIME_APPLICATION_JSON' ) ) {         define( 'MIME_APPLICATION_JSON'            , 'application/json' ); }
    if( ! defined( 'MIME_APPLICATION_XML' ) ) {         define( 'MIME_APPLICATION_XML'            , 'application/xml' ); }
    if( ! defined( 'MIME_MULTIPART_FORM_DATA' ) ) {     define( 'MIME_MULTIPART_FORM_DATA'        , 'multipart/form-data' ); }
    if( ! defined( 'MIME_TEXT_PLAIN' ) ) {                 define( 'MIME_TEXT_PLAIN'                , 'text/plain' ); }
    if( ! defined( 'MIME_TEXT_HTML' ) ) {                 define( 'MIME_TEXT_HTML'                , 'text/html' ); }
    if( ! defined( 'MIME_X_WWW_FORM_URLENCODED' ) ) {     define( 'MIME_X_WWW_FORM_URLENCODED'    , 'application/x-www-form-urlencoded' ); }

    // funzioni richieste
    if( ! function_exists( 'logger' ) ) {
        die( 'la funzione core logger() non è definita, definirla per utilizzare la libreria' );
    }

    /**
     * esegue una chiamata REST
     *
     *
     *
     *
     * TODO documentare
     *
     */
    function restCall( $url, $method = METHOD_GET, $data = NULL, $datatype = MIME_APPLICATION_JSON, $answertype = MIME_APPLICATION_JSON, &$status = NULL, $headers = array(), $user = NULL, $pasw = NULL, &$error = NULL, $token = NULL, $auth = CURLAUTH_BASIC, &$raw = NULL ) {

        // inizializzo l'oggetto CURL
        $curl = curl_init();

        // registro la risposta
        curl_setopt( $curl, CURLOPT_RETURNTRANSFER, true );

        // evito l'inclusione degli header nell'output
        curl_setopt( $curl, CURLOPT_HEADER, false );

        // salto la verifica ssl
        curl_setopt( $curl, CURLOPT_SSL_VERIFYPEER, false );

        // salto la verifica dell'host
        curl_setopt( $curl, CURLOPT_SSL_VERIFYHOST, 2 );

        // imposto un timeout per la connessione
        curl_setopt( $curl, CURLOPT_CONNECTTIMEOUT, 3 );
        curl_setopt( $curl, CURLOPT_TIMEOUT, 5 );

        // autenticazione
        if( $user !== NULL && $pasw !== NULL ) {

            curl_setopt( $curl, CURLOPT_HTTPAUTH, $auth );

            curl_setopt( $curl, CURLOPT_USERPWD, $user . ':' . $pasw );

        } elseif( $token !== NULL ) {

            $headers['Authorization'] = 'Bearer ' . $token;

        }

        // NOTA usare CURLAUTH_BASIC o CURLAUTH_DIGEST secondo bisogna

        // verifico che ci siano dati da inviare
        // NOTA perché questa riga è commentata?!
        // if( $data !== NULL && is_array( $data ) && count( $data ) > 0 ) {
        if( true ) {

            // codifico i dati
            switch( $datatype ) {

                case 'headers':
                    $headers = array_merge( $headers, $data );
                break;

                case MIME_APPLICATION_JSON:
                    $data = json_encode( $data, JSON_UNESCAPED_SLASHES );
                    $headers = array_merge( $headers, array( 'Content-Type' => MIME_APPLICATION_JSON, 'Content-Length' => strlen( $data ) ) );
                    curl_setopt( $curl, CURLOPT_POSTFIELDS, $data );
                break;

                case MIME_X_WWW_FORM_URLENCODED:
                    $data = http_build_query( $data );
                    curl_setopt( $curl, CURLOPT_POSTFIELDS, $data );
                break;

                case MIME_MULTIPART_FORM_DATA:
                    // $data = http_build_query( $data ); // NOTA riga commentata perché in conflitto con l'uso di CURLFile(), fare dei test per verificare se funziona tutto lo stesso
                    curl_setopt( $curl, CURLOPT_POSTFIELDS, $data );
                break;

                case NULL:
                case 'query':
                    if( ! empty( $data ) ) {
                        $data = http_build_query( $data );
                        $url = sprintf( "%s?%s", $url, $data );
                    }
                break;

            }

            // log
            logger( 'invio a ' . $url . ' (' . $method . ') dati: ' . print_r( $data, true ), 'rest' );

        }

        // impostazione del tipo di dati accettato
        if( ! empty( $answertype ) ) {
            $headers = array_merge( $headers, array( 'Accept' => $answertype ) );
        }

        // impostazione degli headers
        if( ! empty( $headers ) ) {
            foreach( $headers as $k => $d ) { $hdrs[] = $k . ': ' . $d; }
            curl_setopt( $curl, CURLOPT_HTTPHEADER, $hdrs );
        }

        // imposto il metodo
        curl_setopt( $curl, CURLOPT_CUSTOMREQUEST, $method );

        // imposto l'url
        curl_setopt( $curl, CURLOPT_URL, $url );

        // debug
        // curl_setopt( $curl, CURLOPT_VERBOSE, true);
        // curl_setopt( $curl, CURLOPT_STDERR, fopen( DIRECTORY_BASE . DIRECTORY_LOG . 'curl.' . date('YmdHis') . '.log', 'w'));

        // esecuzione della chiamata
        $result = curl_exec( $curl );
        $status = curl_getinfo( $curl, CURLINFO_HTTP_CODE );
        $error = curl_error( $curl );

        // debug
        // var_dump( $url );
        // var_dump( $curl );
        // var_dump( $result );
        // var_dump( $status );
        // var_dump( $error );
        // var_dump( $headers );
        // var_dump( $data );

        // log
        if( ! empty( $error ) || substr( $status, 0, 1 ) != 2 ) {
            logger( 'risposta ' . $status . ( ( ! empty( $error ) ) ? '/' . $error : NULL ) . ' ricevuta da ' . $url . ' (' . $method . '): ' . serialize( $result ), 'rest' , LOG_ERR );
        } else {
            logger( 'risposta ' . $status . ' ricevuta da ' . $url . ' (' . $method . '): ' . serialize( $result ), 'rest' );
        }

        // chiusura della richiesta
        curl_close( $curl );

        // salvataggio del risultato grezzo
        $raw = $result;

        // decodifica della risposta
        switch( $answertype ) {

            case MIME_APPLICATION_JSON:
                $result = json_decode( $result , true );
            break;

            case MIME_APPLICATION_XML:
                $result = xml2array( $result );
            break;

        }

        // restituzione della risposta
        return $result;

    }

    /**
     * preleva un valore da una chiamata REST
     *
     * Questa funzione preleva un JSON da una chiamata REST e ne restituisce il valore di una chiave specificata.
     *
     *
     * TODO documentare
     *
     */
    function restGetValue( $k, $url, $data = NULL, $datatype = MIME_APPLICATION_JSON, $answertype = MIME_APPLICATION_JSON, &$status = NULL, $headers = array(), $user = NULL, $pasw = NULL, &$error = NULL ) {

        $r = restCall( $url, METHOD_GET, $data, $datatype, $answertype, $status, $headers, $user, $pasw, $error );

        if( isset( $r[ $k ] ) ) {
            return $r[ $k ];
        } else {
            return false;
        }

    }

    /**
     * preleva un valore singolo da una chiamata REST
     *
     * Questa funzione preleva un valore stringa da una chiamata REST.
     *
     *
     * TODO documentare
     *
     */
    function restGetString( $url ) {

        $r = restCall( $url, METHOD_GET, NULL, MIME_TEXT_PLAIN, MIME_TEXT_PLAIN );

        return $r;

    }
