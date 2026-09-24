<?php

    /**
     * libreria di strumenti REST
     * 
     * Questa libreria contiene le funzioni che il framework usa per chiamare servizi web esterni tramite HTTP, e le
     * costanti per i metodi HTTP e per i tipi di contenuto.
     * 
     * introduzione
     * ============
     * Tutte le chiamate HTTP in uscita del framework e dei moduli (servizi di pagamento, gestionali remoti, geocoding,
     * reCAPTCHA e così via) passano per restCall(), che incapsula cURL: codifica i dati nel formato richiesto, imposta
     * gli header e l'autenticazione, esegue la chiamata, scrive richiesta e risposta nel log rest e decodifica la
     * risposta. Le altre funzioni della libreria sono scorciatoie per i casi più semplici.
     * 
     * I tempi massimi di attesa delle chiamate si possono regolare per tutto il deploy definendo in un runlevel le
     * costanti REST_CONNECTTIMEOUT e REST_TIMEOUT, come spiegato nel commento dentro restCall().
     * 
     * costanti
     * ========
     * Le costanti definite e utilizzate dalla libreria sono elencate nella seguente tabella; ognuna viene definita
     * soltanto se non esiste già, perché le stesse costanti sono dichiarate anche in _src/_config.php.
     *
     * costante                     | spiegazione
     * -----------------------------|--------------------------------------------------------------
     * METHOD_DELETE                | metodo HTTP DELETE
     * METHOD_GET                   | metodo HTTP GET
     * METHOD_PATCH                 | metodo HTTP PATCH
     * METHOD_POST                  | metodo HTTP POST
     * METHOD_PUT                   | metodo HTTP PUT
     * METHOD_REPLACE               | azione REPLACE (non è un metodo HTTP, è usata dalle controller)
     * METHOD_UPDATE                | azione UPDATE (non è un metodo HTTP, è usata dalle controller)
     * MIME_APPLICATION_JSON        | tipo di contenuto application/json
     * MIME_APPLICATION_XML         | tipo di contenuto application/xml
     * MIME_MULTIPART_FORM_DATA     | tipo di contenuto multipart/form-data
     * MIME_TEXT_PLAIN              | tipo di contenuto text/plain
     * MIME_TEXT_HTML               | tipo di contenuto text/html
     * MIME_X_WWW_FORM_URLENCODED   | tipo di contenuto application/x-www-form-urlencoded
     * 
     * La libreria legge inoltre, se definite, le costanti REST_CONNECTTIMEOUT (tempo massimo per la connessione, default
     * 3 secondi) e REST_TIMEOUT (tempo massimo per la risposta, default 5 secondi), che non definisce.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni per le chiamate REST
     * -----------------------------
     * Le funzioni in questo gruppo servono per effettuare chiamate a servizi web esterni.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * restCall()                       | esegue una chiamata REST
     * restGetValue()                   | preleva un valore da una chiamata REST
     * restGetString()                  | preleva un valore singolo da una chiamata REST
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni, oltre all'estensione cURL di PHP:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logger()                         | core
     * xml2array()                      | _src/_lib/_xml.tools.php
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
     * FUNZIONI PER LE CHIAMATE REST
     */

    /**
     * esegue una chiamata REST
     * 
     * Questa funzione esegue con cURL una chiamata HTTP all'URL dato con il metodo dato, e restituisce la risposta
     * decodificata secondo $answertype. I dati vengono codificati secondo $datatype:
     * 
     * datatype                     | trattamento dei dati
     * -----------------------------|--------------------------------------------------------------
     * MIME_APPLICATION_JSON        | codificati in JSON e inviati nel corpo, con gli header Content-Type e Content-Length
     * MIME_X_WWW_FORM_URLENCODED   | codificati con http_build_query() e inviati nel corpo
     * MIME_MULTIPART_FORM_DATA     | passati così come sono a cURL, che li invia come multipart (anche con CURLFile)
     * 'query' o NULL               | codificati con http_build_query() e aggiunti all'URL dopo un ?
     * 'headers'                    | aggiunti agli header della richiesta
     * qualsiasi altro valore       | non inviati
     * 
     * Se $answertype non è vuoto viene inviato l'header Accept; la risposta viene decodificata in array associativo per
     * MIME_APPLICATION_JSON (NULL se il corpo non è JSON valido o è vuoto) e con xml2array() per MIME_APPLICATION_XML,
     * mentre per qualsiasi altro tipo viene restituita la stringa grezza. Se $user e $pasw sono entrambi valorizzati
     * viene usata l'autenticazione HTTP del tipo $auth, altrimenti se c'è $token viene inviato l'header
     * Authorization: Bearer. Gli header vanno passati come array nome => valore. I redirect non vengono seguiti.
     * 
     * La richiesta e la risposta vengono scritte nel log rest, compresi i dati inviati (e quindi anche eventuali
     * credenziali contenute nei dati); le risposte con codice diverso da 2xx o con errore cURL vengono registrate con
     * livello LOG_ERR. La funzione non segnala gli errori con il valore restituito: per sapere com'è andata il chiamante
     * deve leggere $status (0 se il server non ha risposto) ed $error. In caso di errore di rete la risposta è false,
     * che decodificato come JSON diventa NULL.
     * 
     * NOTA siccome il controllo sulla presenza dei dati è disattivato (il blocco è sotto if( true )), con $datatype
     * MIME_APPLICATION_JSON e $data NULL la funzione invia comunque il corpo "null", anche con il metodo GET.
     * NOTA la verifica del certificato SSL del server è disattivata (CURLOPT_SSL_VERIFYPEER a false), per cui la
     * connessione HTTPS non protegge da un server che si spaccia per quello chiamato.
     * NOTA con $datatype 'query' i parametri vengono aggiunti dopo un ? anche se l'URL ne contiene già uno.
     * TODO valutare se riattivare la verifica del certificato SSL
     * 
     * @param       string      $url            l'URL da chiamare
     * @param       string      $method         il metodo HTTP, una delle costanti METHOD_* (default METHOD_GET)
     * @param       mixed       $data           i dati da inviare (default NULL)
     * @param       string      $datatype       il formato dei dati (default MIME_APPLICATION_JSON, vedi tabella)
     * @param       string      $answertype     il formato atteso della risposta (default MIME_APPLICATION_JSON)
     * @param       int         $status         [out] il codice HTTP della risposta, scritto per riferimento
     * @param       array       $headers        gli header aggiuntivi nella forma nome => valore (default nessuno)
     * @param       string      $user           il nome utente per l'autenticazione HTTP (default NULL)
     * @param       string      $pasw           la password per l'autenticazione HTTP (default NULL)
     * @param       string      $error          [out] il messaggio di errore di cURL, vuoto se non ci sono errori
     * @param       string      $token          il token per l'autenticazione Bearer (default NULL)
     * @param       int         $auth           il tipo di autenticazione HTTP, una delle costanti CURLAUTH_* (default
     *                                          CURLAUTH_BASIC)
     * @param       string      $raw            [out] il corpo della risposta non decodificato
     * @param       array       $resHeaders     [out] gli header della risposta, con il nome in minuscolo come chiave e
     *                                          un array di valori; gli header vengono aggiunti a quelli già presenti
     * @param       int         $timeout        il tempo massimo per la risposta in secondi (default NULL, cioè
     *                                          REST_TIMEOUT se definita, altrimenti 5)
     * 
     * @return      mixed                       la risposta decodificata secondo $answertype
     * 
     */
    function restCall( $url, $method = METHOD_GET, $data = NULL, $datatype = MIME_APPLICATION_JSON, $answertype = MIME_APPLICATION_JSON, &$status = NULL, $headers = array(), $user = NULL, $pasw = NULL, &$error = NULL, $token = NULL, $auth = CURLAUTH_BASIC, &$raw = NULL, &$resHeaders = array(), $timeout = NULL ) {

        // inizializzo l'oggetto CURL
        $curl = curl_init();

        // registro la risposta
        curl_setopt( $curl, CURLOPT_RETURNTRANSFER, true );

        // evito l'inclusione degli header nell'output
        curl_setopt( $curl, CURLOPT_HEADER, false );

        // gestisco gli header di risposta
        curl_setopt( $curl, CURLOPT_HEADERFUNCTION,
            function( $curl, $header ) use ( &$resHeaders ) {
                $len = strlen( $header );
                $header = explode(':', $header, 2);
                if (count($header) < 2) {
                    return $len;
                }
                $resHeaders[ strtolower( trim( $header[0] ) ) ][] = trim( $header[1] );
                return $len;
            }
        );

        // salto la verifica ssl
        curl_setopt( $curl, CURLOPT_SSL_VERIFYPEER, false );

        // salto la verifica dell'host
        curl_setopt( $curl, CURLOPT_SSL_VERIFYHOST, 2 );

        // imposto un timeout per la connessione
        //
        // Il valore storico — 3 secondi per la connessione, 5 per la risposta — resta il default,
        // quindi nessun deploy cambia comportamento senza dire niente. Si scavalca in due modi:
        // per singola chiamata con $timeout, oppure per tutto il deploy definendo le costanti
        // REST_CONNECTTIMEOUT e REST_TIMEOUT in un runlevel. Le costanti si leggono qui, a ogni
        // chiamata e non al caricamento della libreria, perché le librerie vengono incluse PRIMA
        // dei runlevel: un define fatto in un runlevel fa comunque in tempo.
        //
        // Perché serve: cinque secondi bastano per una lettura, non sempre per una scrittura su
        // un gestionale remoto. E una scrittura che va in timeout è il caso peggiore, perché la
        // risposta non arriva ma la INSERT dall'altra parte può essere passata lo stesso: chi
        // chiama non sa se ripetere o no. Sul deploy GIMBE questo ha prodotto, fra il marzo 2024
        // e il maggio 2026, 22 donazioni che il sito dava per non registrate — di cui 8 erano
        // invece sul gestionale, e una registrata due volte.
        $connectTimeout = defined( 'REST_CONNECTTIMEOUT' ) ? REST_CONNECTTIMEOUT : 3;
        $responseTimeout = ( $timeout !== NULL ) ? $timeout : ( defined( 'REST_TIMEOUT' ) ? REST_TIMEOUT : 5 );

        curl_setopt( $curl, CURLOPT_CONNECTTIMEOUT, $connectTimeout );
        curl_setopt( $curl, CURLOPT_TIMEOUT, $responseTimeout );

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
     * La chiamata viene fatta con restCall() sempre con il metodo GET; se la risposta non contiene la chiave (o se la
     * chiamata fallisce) la funzione restituisce false, per cui un valore false o NULL nella risposta è
     * indistinguibile da una chiave assente.
     *
     * @param       string      $k              la chiave di cui restituire il valore
     * @param       string      $url            l'URL da chiamare
     * @param       mixed       $data           i dati da inviare (default NULL)
     * @param       string      $datatype       il formato dei dati (default MIME_APPLICATION_JSON)
     * @param       string      $answertype     il formato atteso della risposta (default MIME_APPLICATION_JSON)
     * @param       int         $status         [out] il codice HTTP della risposta, scritto per riferimento
     * @param       array       $headers        gli header aggiuntivi nella forma nome => valore (default nessuno)
     * @param       string      $user           il nome utente per l'autenticazione HTTP (default NULL)
     * @param       string      $pasw           la password per l'autenticazione HTTP (default NULL)
     * @param       string      $error          [out] il messaggio di errore di cURL, scritto per riferimento
     *
     * @return      mixed                       il valore della chiave, oppure false se non è presente
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
     * La chiamata viene fatta con restCall() con il metodo GET, senza dati e con Accept text/plain, e la risposta viene
     * restituita così com'è, senza decodifica; in caso di errore di rete la funzione restituisce false.
     *
     * @param       string      $url            l'URL da chiamare
     *
     * @return      mixed                       il corpo della risposta, oppure false in caso di errore di rete
     *
     */
    function restGetString( $url ) {

        $r = restCall( $url, METHOD_GET, NULL, MIME_TEXT_PLAIN, MIME_TEXT_PLAIN );

        return $r;

    }
