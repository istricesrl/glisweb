<?php

    /**
     * server finto del WMS Modula, per i test
     *
     * Risponde come il WMS col protocollo WebService 1.11, cosi' le funzioni di _src/_lib/_modula.utils.php si
     * collaudano senza il magazzino. Si chiama col percorso del servizio dopo il nome del file:
     *
     * percorso                 | cosa fa
     * -------------------------|---------------------------------------------------------------------------------
     * POST /token              | con utente modula e password fake da' il token, altrimenti 400 invalid_grant
     * POST /api/jobs/{job}     | import: valida IMP_ORDINI e IMP_ORDINI_RIGHE, li tiene e risponde 200, o 400
     *                          | con la descrizione dell'errore
     * GET  /api/jobs/{job}     | export: un pacchetto di al massimo due ordini, evasi per intero tranne le righe
     *                          | dell'articolo MANCA, che tornano a "0,000"; finche' non arriva l'ack ripete lo
     *                          | stesso; senza ordini risponde 204
     * POST /api/jobs/{job}/ack | conferma il pacchetto col suo GUID e ne cancella gli ordini; GUID sbagliato 400
     * POST /reset              | solo del finto: cancella ordini e pacchetto
     *
     * Tutto tranne /token vuole Basic ( modula / fake ) oppure il Bearer emesso, altrimenti 401 come il WMS.
     *
     * Il file NON fa il bootstrap del framework, di proposito: le credenziali finte in Basic e in Bearer
     * verrebbero prese per un login ( _src/_config/_210.auth.php ) e finirebbero nel log come accessi falliti.
     * Per lo stesso motivo non sa niente dei profili: lo stato sta in var/spool/modula/fake/.
     *
     * Il WMS non disponibile NON si simula qui: un 5xx vero finirebbe nell'access.log del deploy, e i controlli
     * dei log ( log-deploy.py ) lo prenderebbero per un guasto a ogni giro di test. Gli esempi lo simulano dal
     * client, puntando il profilo su una porta chiusa.
     *
     * Risponde solo se esiste il file var/test/modula.fake.on con meno di dieci minuti, che gli esempi di
     * _usr/_examples/_lib/_modula.utils/ creano prima di chiamarlo; altrimenti 404. Per usarlo a mano:
     *
     *     touch var/test/modula.fake.on
     *
     */

    // cartella del deploy
    $base = dirname( __DIR__, 5 ) . '/';

    // interruttore
    $interruttore = $base . 'var/test/modula.fake.on';
    if( ! file_exists( $interruttore ) || filemtime( $interruttore ) < time() - 600 ) {
        http_response_code( 404 );
        exit;
    }

    // costanti del finto
    $utente = 'modula';
    $password = 'fake';
    $pacchettoMax = 2;
    $corpoMax = 1048576;

    // stato
    $cartella = $base . 'var/spool/modula/fake/';
    if( ! is_dir( $cartella ) ) {
        mkdir( $cartella, 0770, true );
    }
    $lock = fopen( $cartella . 'lock', 'c' );
    flock( $lock, LOCK_EX );
    $stato = ( file_exists( $cartella . 'stato.json' ) ) ? json_decode( file_get_contents( $cartella . 'stato.json' ), true ) : NULL;
    if( ! is_array( $stato ) ) {
        $stato = array( 'ordini' => array(), 'pacchetto' => NULL, 'token' => array() );
    }

    /**
     * risposta e uscita
     *
     * @param    int       codice    il codice HTTP
     * @param    mixed     corpo     array da mandare in JSON, stringa da mandare cosi' com'e', NULL per niente
     *
     */
    function rispondi( $codice, $corpo = NULL ) {

        global $cartella, $stato;

        file_put_contents( $cartella . 'stato.json', json_encode( $stato ) );

        http_response_code( $codice );

        if( is_array( $corpo ) ) {
            header( 'Content-Type: application/json; charset=utf-8' );
            echo json_encode( $corpo, JSON_UNESCAPED_SLASHES );
        } elseif( $corpo !== NULL ) {
            header( 'Content-Type: text/plain; charset=utf-8' );
            echo $corpo;
        }

        exit;

    }

    // richiesta
    $metodo = $_SERVER['REQUEST_METHOD'];
    $percorso = ( isset( $_SERVER['PATH_INFO'] ) ) ? rtrim( $_SERVER['PATH_INFO'], '/' ) : '';
    if( isset( $_SERVER['CONTENT_LENGTH'] ) && $_SERVER['CONTENT_LENGTH'] > $corpoMax ) {
        rispondi( 413, 'Request Entity Too Large' );
    }
    $corpo = file_get_contents( 'php://input', false, NULL, 0, $corpoMax );

    // token
    if( $metodo == 'POST' && $percorso == '/token' ) {
        parse_str( $corpo, $form );
        if( ! isset( $form['grant_type'], $form['username'], $form['password'] ) || $form['grant_type'] != 'password' ) {
            rispondi( 400, array( 'error' => 'unsupported_grant_type' ) );
        }
        if( $form['username'] !== $utente || $form['password'] !== $password ) {
            rispondi( 400, array( 'error' => 'invalid_grant', 'error_description' => 'Username and password do not match.' ) );
        }
        $token = bin2hex( random_bytes( 32 ) );
        $stato['token'] = array_slice( array_merge( $stato['token'], array( $token ) ), -10 );
        rispondi( 200, array( 'access_token' => $token, 'token_type' => 'bearer', 'expires_in' => 86399 ) );
    }

    // autenticazione
    $autorizzazione = '';
    foreach( array( 'HTTP_AUTHORIZATION', 'REDIRECT_HTTP_AUTHORIZATION' ) as $chiave ) {
        if( ! empty( $_SERVER[ $chiave ] ) ) {
            $autorizzazione = $_SERVER[ $chiave ];
        }
    }
    if( empty( $autorizzazione ) && function_exists( 'getallheaders' ) ) {
        foreach( getallheaders() as $nome => $valore ) {
            if( strtolower( $nome ) == 'authorization' ) {
                $autorizzazione = $valore;
            }
        }
    }
    $autenticato = false;
    if( isset( $_SERVER['PHP_AUTH_USER'], $_SERVER['PHP_AUTH_PW'] ) ) {
        $autenticato = ( $_SERVER['PHP_AUTH_USER'] === $utente && $_SERVER['PHP_AUTH_PW'] === $password );
    } elseif( stripos( $autorizzazione, 'Basic ' ) === 0 ) {
        $autenticato = ( base64_decode( substr( $autorizzazione, 6 ) ) === $utente . ':' . $password );
    } elseif( stripos( $autorizzazione, 'Bearer ' ) === 0 ) {
        $autenticato = in_array( trim( substr( $autorizzazione, 7 ) ), $stato['token'], true );
    }
    if( ! $autenticato ) {
        rispondi( 401, array( 'Message' => 'Authorization has been denied for this request.' ) );
    }

    // reset
    if( $metodo == 'POST' && $percorso == '/reset' ) {
        $stato = array( 'ordini' => array(), 'pacchetto' => NULL, 'token' => $stato['token'] );
        rispondi( 200 );
    }

    // job
    if( ! preg_match( '#^/api/jobs/([^/]+)(/ack)?$#', $percorso, $job ) ) {
        rispondi( 404, 'Not Found' );
    }

    // ack
    if( $metodo == 'POST' && ! empty( $job[2] ) ) {
        $dati = json_decode( $corpo, true );
        if( empty( $stato['pacchetto'] ) || ! isset( $dati['GUID'] ) || $dati['GUID'] !== $stato['pacchetto']['GUID'] ) {
            rispondi( 400, 'GUID non valido o pacchetto gia\' confermato' );
        }
        foreach( $stato['pacchetto']['DATA']['EXP_ORDINI'] as $ordine ) {
            unset( $stato['ordini'][ $ordine['ORD_ORDINE'] ] );
        }
        $stato['pacchetto'] = NULL;
        rispondi( 200 );
    }

    // import
    if( $metodo == 'POST' ) {

        $dati = json_decode( $corpo, true );
        if( ! is_array( $dati ) || ! isset( $dati['IMP_ORDINI'], $dati['IMP_ORDINI_RIGHE'] ) || ! is_array( $dati['IMP_ORDINI'] ) || ! is_array( $dati['IMP_ORDINI_RIGHE'] ) ) {
            rispondi( 400, 'formato non valido: servono IMP_ORDINI e IMP_ORDINI_RIGHE' );
        }

        $ordini = array();
        foreach( $dati['IMP_ORDINI'] as $i => $ordine ) {
            if( empty( $ordine['ORD_ORDINE'] ) ) {
                rispondi( 400, 'IMP_ORDINI[' . $i . ']: ORD_ORDINE mancante' );
            }
            if( ! isset( $ordine['ORD_TIPOOP'] ) || ! in_array( $ordine['ORD_TIPOOP'], array( 'P', 'V' ), true ) ) {
                rispondi( 400, 'IMP_ORDINI[' . $i . ']: ORD_TIPOOP non valido' );
            }
            $ordini[ $ordine['ORD_ORDINE'] ] = array( 'ordine' => $ordine, 'righe' => array() );
        }

        foreach( $dati['IMP_ORDINI_RIGHE'] as $i => $riga ) {
            if( empty( $riga['RIG_ORDINE'] ) || ! isset( $ordini[ $riga['RIG_ORDINE'] ] ) ) {
                rispondi( 400, 'IMP_ORDINI_RIGHE[' . $i . ']: RIG_ORDINE assente fra gli ordini del pacchetto' );
            }
            if( empty( $riga['RIG_ARTICOLO'] ) ) {
                rispondi( 400, 'IMP_ORDINI_RIGHE[' . $i . ']: RIG_ARTICOLO mancante' );
            }
            if( ! isset( $riga['RIG_QTAR'] ) || ! is_string( $riga['RIG_QTAR'] ) || ! preg_match( '/^\d+,\d{3}$/', $riga['RIG_QTAR'] ) ) {
                rispondi( 400, 'IMP_ORDINI_RIGHE[' . $i . ']: RIG_QTAR non valida, atteso testo come "1,000"' );
            }
            $ordini[ $riga['RIG_ORDINE'] ]['righe'][] = $riga;
        }

        $stato['ordini'] = array_merge( $stato['ordini'], $ordini );
        rispondi( 200 );

    }

    // export
    if( $metodo == 'GET' ) {

        if( empty( $stato['pacchetto'] ) ) {

            if( empty( $stato['ordini'] ) ) {
                rispondi( 204 );
            }

            $evasi = array( 'EXP_ORDINI' => array(), 'EXP_ORDINI_RIGHE' => array() );
            foreach( array_slice( $stato['ordini'], 0, $pacchettoMax, true ) as $ordine ) {
                $evasi['EXP_ORDINI'][] = $ordine['ordine'];
                foreach( $ordine['righe'] as $riga ) {
                    $riga['RIG_QTAE'] = ( $riga['RIG_ARTICOLO'] == 'MANCA' ) ? '0,000' : $riga['RIG_QTAR'];
                    $evasi['EXP_ORDINI_RIGHE'][] = $riga;
                }
            }

            $stato['pacchetto'] = array(
                'GUID' => vsprintf( '%s%s-%s-%s-%s-%s%s%s', str_split( bin2hex( random_bytes( 16 ) ), 4 ) ),
                'TransactionStatus' => ( count( $stato['ordini'] ) > $pacchettoMax ) ? 'CHUNK' : 'END',
                'DATA' => $evasi
            );

        }

        rispondi( 200, $stato['pacchetto'] );

    }

    rispondi( 405, 'Method Not Allowed' );
