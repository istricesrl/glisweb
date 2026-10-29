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
     * costanti REST_CONNECTTIMEOUT e REST_TIMEOUT, come spiegato nel commento dentro restCall(). Allo stesso modo la
     * costante REST_SSL_VERIFY, definita a false, disattiva la verifica del certificato del server, che è attiva per
     * default: serve solo ai deploy di sviluppo con un certificato self-signed.
     * 
     * Durante i test automatici le chiamate verso i servizi elencati in configurazione non escono dalla macchina:
     * _src/_config/_595.rest.php definisce le costanti REST_MOCK_URL e REST_MOCK_HOSTS, e restCall() manda quelle
     * chiamate al finto REST avviato da _src/_sh/_codeception.run.sh ( vedi restMockUrl() e _usr/_test/_rest.mock.php ).
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
     * 3 secondi), REST_TIMEOUT (tempo massimo per la risposta, default 5 secondi), REST_SSL_VERIFY (verifica del
     * certificato del server, default true) e REST_LOG_SECRETS (scrittura in chiaro nel log rest di password, secret e
     * token, default false), che non definisce.
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
     * restMaskSecrets()                | maschera password, secret e token prima di scriverli nel log
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni, oltre all'estensione cURL di PHP:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logger()                         | core
     * array2xml()                      | _src/_lib/_xml.tools.php
     * xml2array()                      | _src/_lib/_xml.tools.php
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     * 2026-09-25       | Fabio Mosti          | invio dei dati in XML con MIME_APPLICATION_XML
     * 2026-10-15       | Fabio Mosti          | password, secret e token mascherati nel log rest
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
     * MIME_APPLICATION_XML         | convertiti con array2xml() se sono un array, altrimenti inviati come sono, nel corpo, come per JSON
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
     * La richiesta e la risposta vengono scritte nel log rest, compresi i dati inviati, ma con i valori di password,
     * secret e token sostituiti da *** ( si veda restMaskSecrets() ); le risposte con codice diverso da 2xx o con errore cURL vengono registrate con
     * livello LOG_ERR. La funzione non segnala gli errori con il valore restituito: per sapere com'è andata il chiamante
     * deve leggere $status (0 se il server non ha risposto) ed $error. In caso di errore di rete la risposta è false,
     * che decodificato come JSON diventa NULL.
     * 
     * Con il metodo GET e $data NULL i dati non vengono codificati e la richiesta parte senza corpo; con gli altri
     * metodi, $datatype MIME_APPLICATION_JSON e $data NULL la funzione invia il corpo "null" con l'header Content-Type
     * ( si veda il commento nel corpo ); con MIME_APPLICATION_XML nello stesso caso il corpo è vuoto, con Content-Length 0.
     * Il certificato SSL del server e il suo nome vengono verificati, a meno che il deploy non abbia definito la
     * costante REST_SSL_VERIFY a false ( si veda il commento nel corpo ).
     * NOTA con $datatype 'query' i parametri vengono aggiunti dopo un ? anche se l'URL ne contiene già uno.
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

        // verifica del certificato del server
        //
        // Fino al 2026-09-24 CURLOPT_SSL_VERIFYPEER era a false per tutti, per cui una chiamata HTTPS non
        // proteggeva da un server che si spacciasse per quello chiamato, e credenziali, token e dati di
        // pagamento finivano a lui. Adesso il certificato si verifica sempre, e il deploy che ha bisogno di
        // non farlo lo dice esplicitamente definendo in un runlevel la costante REST_SSL_VERIFY a
        // false. Il caso reale sono le chiamate che il sito fa a se stesso su $cf['site']['url'] ( la stampa
        // di documento.pdf e fattura.xml nel modulo 0400.documenti ): su un deploy di sviluppo con certificato
        // self-signed senza la costante falliscono. Come per i timeout, la costante si legge a ogni chiamata.
        $sslVerify = defined( 'REST_SSL_VERIFY' ) ? (bool) REST_SSL_VERIFY : true;

        curl_setopt( $curl, CURLOPT_SSL_VERIFYPEER, $sslVerify );
        curl_setopt( $curl, CURLOPT_SSL_VERIFYHOST, ( $sslVerify ) ? 2 : 0 );

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
        //
        // NB: senza dati si salta la codifica solo in GET, dove prima con MIME_APPLICATION_JSON partiva il corpo
        // "null"; negli altri metodi il corpo "null" resta, perché le capture di PayPal ( _paypal.advanced.capture.php
        // in _F030.pagamenti e _4170.ecommerce ) fanno una POST senza dati e ricevono da questo blocco l'header
        // Content-Type: application/json che l'API di PayPal richiede, e togliere il corpo cambierebbe una chiamata che
        // oggi funziona ( 2026-09-24 )
        if( $data !== NULL || $method != METHOD_GET ) {

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

                case MIME_APPLICATION_XML:
                    if( is_array( $data ) ) {
                        $data = array2xml( $data );
                    }
                    $data = (string) $data;
                    $headers = array_merge( $headers, array( 'Content-Type' => MIME_APPLICATION_XML, 'Content-Length' => strlen( $data ) ) );
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

        }

        // finto REST dei test
        //
        // Durante i test automatici _595.rest.php definisce REST_MOCK_URL e REST_MOCK_HOSTS, e la chiamata verso uno di
        // quegli host va al finto REST avviato da _codeception.run.sh invece che al servizio vero: i test non devono
        // scrivere su un gestionale o un servizio di pagamento che non ha un ambiente di prova. Lo si fa qui, prima del
        // log, cosi' il log rest dice dove e' andata davvero la chiamata.
        if( defined( 'REST_MOCK_URL' ) && defined( 'REST_MOCK_HOSTS' ) ) {
            $url = restMockUrl( $url, REST_MOCK_URL, REST_MOCK_HOSTS );
        }

        // log
        //
        // Il corpo della chiamata nel log serve per il debug e resta, ma i valori delle chiavi che contengono
        // credenziali escono mascherati: fino al 2026-10-15 la chiamata del token di Modula ( corpo urlencoded )
        // lasciava nel log rest la password in chiaro, e il token nella risposta. Per vedere tutto in chiaro durante
        // una sessione di debug si definisce in un runlevel la costante REST_LOG_SECRETS a true; la si legge a ogni
        // chiamata, come le altre costanti REST_*.
        $logSecrets = defined( 'REST_LOG_SECRETS' ) && REST_LOG_SECRETS;
        logger( 'invio a ' . ( ( $logSecrets ) ? $url : restMaskSecrets( $url ) ) . ' (' . $method . ') dati: ' . print_r( ( $logSecrets ) ? $data : restMaskSecrets( $data ), true ), 'rest' );

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
        $logUrl = ( $logSecrets ) ? $url : restMaskSecrets( $url );
        $logResult = ( $logSecrets ) ? $result : restMaskSecrets( $result );
        if( ! empty( $error ) || substr( $status, 0, 1 ) != 2 ) {
            logger( 'risposta ' . $status . ( ( ! empty( $error ) ) ? '/' . $error : NULL ) . ' ricevuta da ' . $logUrl . ' (' . $method . '): ' . serialize( $logResult ), 'rest' , LOG_ERR );
        } else {
            logger( 'risposta ' . $status . ' ricevuta da ' . $logUrl . ' (' . $method . '): ' . serialize( $logResult ), 'rest' );
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

    /**
     * maschera password, secret e token prima di scriverli nel log
     * 
     * Questa funzione restituisce una copia dei dati in cui i valori delle chiavi che contengono credenziali sono
     * sostituiti da ***, e tutto il resto è lasciato com'è: serve a restCall() per scrivere nel log rest la richiesta e
     * la risposta, che per il debug servono intere, senza lasciarci password e token in chiaro.
     * 
     * Una chiave contiene credenziali se nel nome ( senza distinzione fra maiuscole e minuscole, e dopo urldecode() )
     * compare pass, pasw, pwd, secret, apikey o api_key, oppure se finisce per token: quindi password, client_secret,
     * access_token, refreshToken e login[password] sì, token_type e expires_in no.
     * 
     * I dati possono essere:
     * 
     * tipo                         | trattamento
     * -----------------------------|--------------------------------------------------------------
     * array                        | le chiavi vengono controllate ricorsivamente
     * stringa                      | vengono riconosciute le coppie chiave/valore in JSON ( "chiave": valore ), in
     *                              | query string o corpo urlencoded ( chiave=valore ) e in XML ( <chiave>valore</chiave> )
     * qualsiasi altro valore       | restituito com'è
     * 
     * Un valore vuoto resta vuoto, perché nel debug sapere che una credenziale non è stata inviata è utile quanto
     * saperne il valore.
     * 
     * @param       mixed       $data           i dati da mascherare
     * 
     * @return      mixed                       i dati con i valori delle credenziali sostituiti da ***
     * 
     */
    function restMaskSecrets( $data ) {

        // riconoscimento delle chiavi che contengono credenziali
        $secret = function( $k ) {
            $k = strtolower( urldecode( $k ) );
            return preg_match( '/pass|pasw|pwd|secret|api_?key|token\]?$/', $k ) === 1;
        };

        // array
        if( is_array( $data ) ) {
            foreach( $data as $k => $v ) {
                if( $secret( $k ) && ! is_array( $v ) && $v !== '' && $v !== NULL ) {
                    $data[ $k ] = '***';
                } else {
                    $data[ $k ] = restMaskSecrets( $v );
                }
            }
            return $data;
        }

        // altri valori che non sono stringhe
        if( ! is_string( $data ) ) {
            return $data;
        }

        // JSON: "chiave": "valore" oppure "chiave": valore non stringa
        $data = preg_replace_callback( '/("([^"\\\\]*)"\s*:\s*)("(?:[^"\\\\]|\\\\.)*"|[^\s,}\]"]+)/', function( $m ) use ( $secret ) {
            return ( $secret( $m[2] ) && $m[3] !== '""' && $m[3] !== 'null' ) ? $m[1] . '"***"' : $m[0];
        }, $data );

        // query string e corpo urlencoded: chiave=valore
        $data = preg_replace_callback( '/(^|[?&])([^=&?\s]+)=([^&\s]*)/', function( $m ) use ( $secret ) {
            return ( $secret( $m[2] ) && $m[3] !== '' ) ? $m[1] . $m[2] . '=***' : $m[0];
        }, $data );

        // XML: <chiave>valore</chiave>
        $data = preg_replace_callback( '/<([A-Za-z_][\w.:-]*)(\s[^>]*)?>([^<]+)<\/\1>/', function( $m ) use ( $secret ) {
            return ( $secret( $m[1] ) ) ? '<' . $m[1] . $m[2] . '>***</' . $m[1] . '>' : $m[0];
        }, $data );

        return $data;

    }

    /**
     * devia un URL verso il finto REST dei test
     *
     * Se l'host dell'URL è fra quelli elencati, la funzione restituisce l'URL del finto REST seguito dall'host e dal
     * percorso originali, così il finto servizio sa a chi era diretta la chiamata: con il finto REST su
     * http://127.0.0.1:8790, https://api.esempio.test/v1/ordini?id=7 diventa
     * http://127.0.0.1:8790/api.esempio.test/v1/ordini?id=7. Gli altri URL tornano invariati, e così anche quelli
     * che parse_url() non riesce a leggere. L'host si confronta senza distinzione fra maiuscole e minuscole.
     *
     * La chiama restCall() quando sono definite le costanti REST_MOCK_URL e REST_MOCK_HOSTS ( vedi
     * _src/_config/_595.rest.php ); è separata da restCall() perché si possa verificare senza fare chiamate.
     *
     * @param       string      $url            l'URL della chiamata
     * @param       string      $mock           l'URL del finto REST, senza barra finale
     * @param       array       $hosts          gli host da deviare
     *
     * @return      string                      l'URL da chiamare
     *
     */
    function restMockUrl( $url, $mock, $hosts ) {

        $parti = parse_url( $url );

        if( empty( $parti['host'] ) || ! in_array( strtolower( $parti['host'] ), array_map( 'strtolower', $hosts ) ) ) {
            return $url;
        }

        return $mock . '/' . strtolower( $parti['host'] )
            . ( ( isset( $parti['path'] ) ) ? $parti['path'] : '/' )
            . ( ( isset( $parti['query'] ) ) ? '?' . $parti['query'] : '' );

    }
