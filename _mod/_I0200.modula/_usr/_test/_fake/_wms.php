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
     * POST /api/jobs/{job}     | import: IMP_ARTICOLI aggiorna l'anagrafica; IMP_ORDINI e IMP_ORDINI_RIGHE
     *                          | inseriscono ( I: testata aggiornata, righe aggiunte per RIG_HOSTINF ) o
     *                          | cancellano ( D, con ORD_DEL_SINGOLE_RIGHE le sole righe ) gli ordini; un ordine
     *                          | non in attesa non si cancella, e una riga su un articolo fuori anagrafica ( o
     *                          | ASSENTE ) fa rifiutare il pacchetto intero, col 400 in JSON del WMS; un corpo
     *                          | non riconosciuto prende 200, come sul WMS
     * GET  /api/jobs/{job}     | export: col job delle giacenze le quantita' impostate con /giacenze, con
     *                          | gli altri lo stato di al massimo due ordini, come CFG-EXP-ORDRIG-STATO; alla
     *                          | lettura gli ordini si eseguono: righe C per intero, tranne gli articoli MANCA
     *                          | ( I a zero ), PARZIALE ( I a meta' ), ATTESA ( W ) e LANCIATO ( E ); finche'
     *                          | non arriva l'ack ripete lo stesso pacchetto; senza dati risponde 204
     * POST /api/jobs/{job}/ack | conferma il pacchetto del job col suo GUID, e gli ordini COMPL spariscono;
     *                          | GUID sbagliato 400
     * POST /giacenze           | solo del finto: imposta le giacenze, { "codice": quantita', … }
     * POST /evasioni           | solo del finto: fissa l'evaso per RIG_HOSTINF, { "hostinf": quantita', … }, e la
     *                          | riga torna I se l'evaso e' minore del richiesto
     * POST /reset              | solo del finto: cancella ordini, anagrafica, giacenze, evasioni e pacchetti
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
        $stato = array( 'ordini' => array(), 'articoli' => array(), 'giacenze' => array(), 'pacchetti' => array(), 'token' => array() );
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
        $stato = array( 'ordini' => array(), 'articoli' => array(), 'giacenze' => array(), 'evasioni' => array(), 'pacchetti' => array(), 'token' => $stato['token'] );
        rispondi( 200 );
    }

    // evasioni forzate del finto, impostate dal test: RIG_HOSTINF => quantita' evasa
    if( $metodo == 'POST' && $percorso == '/evasioni' ) {
        $dati = json_decode( $corpo, true );
        $stato['evasioni'] = ( is_array( $dati ) ) ? $dati : array();
        rispondi( 200 );
    }

    // giacenze del finto, impostate dal test: codice => quantita'
    if( $metodo == 'POST' && $percorso == '/giacenze' ) {
        $dati = json_decode( $corpo, true );
        $stato['giacenze'] = ( is_array( $dati ) ) ? $dati : array();
        rispondi( 200 );
    }

    // job
    if( ! preg_match( '#^/api/jobs/([^/]+)(/ack)?$#', $percorso, $job ) ) {
        rispondi( 404, 'Not Found' );
    }

    /**
     * errore sui dati, nel formato del WMS
     *
     * @param    string    primario    la descrizione dell'errore
     * @param    array     testata     la testata dell'ordine
     * @param    array     riga        la riga in errore
     *
     */
    function rifiuta( $primario, $testata = array(), $riga = array() ) {
        rispondi( 400, array( array(
            'PrimaryError' => $primario,
            'SecondaryError' => '',
            'MasterRow' => array_values( $testata ),
            'SlaveRow' => array_values( $riga )
        ) ) );
    }

    // ack
    if( $metodo == 'POST' && ! empty( $job[2] ) ) {
        $dati = json_decode( $corpo, true );
        if( empty( $stato['pacchetti'][ $job[1] ] ) || ! isset( $dati['GUID'] ) || $dati['GUID'] !== $stato['pacchetti'][ $job[1] ]['GUID'] ) {
            rispondi( 400, 'GUID non valido o pacchetto gia\' confermato' );
        }
        if( isset( $stato['pacchetti'][ $job[1] ]['DATA']['EXP_ORDINI'] ) ) {
            foreach( $stato['pacchetti'][ $job[1] ]['DATA']['EXP_ORDINI'] as $ordine ) {
                if( $ordine['ORD_STATO'] == 'COMPL' ) {
                    unset( $stato['ordini'][ $ordine['ORD_ORDINE'] ] );
                }
            }
        }
        $stato['pacchetti'][ $job[1] ] = NULL;
        rispondi( 200, 'Operazione completata con successo' );
    }

    // import
    if( $metodo == 'POST' ) {

        $dati = json_decode( $corpo, true );
        if( ! is_array( $dati ) ) {
            rispondi( 400, 'formato non valido' );
        }

        // anagrafica: ART_OPERAZIONE I inserisce o aggiorna, D cancella
        if( isset( $dati['IMP_ARTICOLI'] ) ) {
            $articoli = $stato['articoli'];
            foreach( $dati['IMP_ARTICOLI'] as $i => $articolo ) {
                if( empty( $articolo['ART_ARTICOLO'] ) || empty( $articolo['ART_UMI'] ) ) {
                    rifiuta( 'Articolo - campi obbligatori mancanti !', array(), $articolo );
                }
                if( isset( $articolo['ART_OPERAZIONE'] ) && $articolo['ART_OPERAZIONE'] == 'D' ) {
                    unset( $articoli[ $articolo['ART_ARTICOLO'] ] );
                } else {
                    $articoli[ $articolo['ART_ARTICOLO'] ] = $articolo;
                }
            }
            $stato['articoli'] = $articoli;
            rispondi( 200, 'Operazione completata con successo' );
        }

        // un corpo che il job non riconosce prende 200, come sul WMS
        if( ! isset( $dati['IMP_ORDINI'] ) || ! is_array( $dati['IMP_ORDINI'] ) ) {
            rispondi( 200, 'Operazione completata con successo' );
        }
        if( ! isset( $dati['IMP_ORDINI_RIGHE'] ) || ! is_array( $dati['IMP_ORDINI_RIGHE'] ) ) {
            $dati['IMP_ORDINI_RIGHE'] = array();
        }

        // il pacchetto e' transazionale: si lavora su una copia e la si tiene solo se va tutto bene
        $ordini = $stato['ordini'];

        // righe per ordine
        $righe = array();
        foreach( $dati['IMP_ORDINI_RIGHE'] as $i => $riga ) {
            if( empty( $riga['RIG_ORDINE'] ) ) {
                rispondi( 400, 'IMP_ORDINI_RIGHE[' . $i . ']: RIG_ORDINE mancante' );
            }
            if( empty( $riga['RIG_ARTICOLO'] ) ) {
                rispondi( 400, 'IMP_ORDINI_RIGHE[' . $i . ']: RIG_ARTICOLO mancante' );
            }
            if( ! isset( $riga['RIG_QTAR'] ) || ! is_string( $riga['RIG_QTAR'] ) || ! preg_match( '/^\d+,\d{3}$/', $riga['RIG_QTAR'] ) ) {
                rispondi( 400, 'IMP_ORDINI_RIGHE[' . $i . ']: RIG_QTAR non valida, atteso testo come "1,000"' );
            }
            $righe[ $riga['RIG_ORDINE'] ][] = $riga;
        }

        foreach( $dati['IMP_ORDINI'] as $i => $ordine ) {

            if( empty( $ordine['ORD_ORDINE'] ) ) {
                rispondi( 400, 'IMP_ORDINI[' . $i . ']: ORD_ORDINE mancante' );
            }
            if( ! isset( $ordine['ORD_TIPOOP'] ) || ! in_array( $ordine['ORD_TIPOOP'], array( 'P', 'V' ), true ) ) {
                rispondi( 400, 'IMP_ORDINI[' . $i . ']: ORD_TIPOOP non valido' );
            }

            $codice = $ordine['ORD_ORDINE'];
            $operazione = ( isset( $ordine['ORD_OPERAZIONE'] ) ) ? $ordine['ORD_OPERAZIONE'] : 'I';
            $sue = ( isset( $righe[ $codice ] ) ) ? $righe[ $codice ] : array();

            // cancellazione: dell'ordine intero, o delle sole righe elencate con ORD_DEL_SINGOLE_RIGHE
            if( $operazione == 'D' ) {
                if( ! isset( $ordini[ $codice ] ) ) {
                    continue;
                }
                if( $ordini[ $codice ]['ordine']['ORD_STATO'] != 'WAIT' ) {
                    rifiuta( 'Ordine non cancellabile !', $ordine );
                }
                if( ! empty( $ordine['ORD_DEL_SINGOLE_RIGHE'] ) ) {
                    foreach( $sue as $riga ) {
                        unset( $ordini[ $codice ]['righe'][ $riga['RIG_HOSTINF'] ] );
                    }
                } else {
                    unset( $ordini[ $codice ] );
                }
                continue;
            }

            // inserimento o aggiornamento: la testata si aggiorna, le righe si aggiungono per RIG_HOSTINF
            if( ! isset( $ordini[ $codice ] ) ) {
                $ordini[ $codice ] = array( 'ordine' => array(), 'righe' => array() );
            }
            $ordine['ORD_STATO'] = 'WAIT';
            $ordini[ $codice ]['ordine'] = array_replace( $ordini[ $codice ]['ordine'], $ordine );
            foreach( $sue as $n => $riga ) {
                if( $riga['RIG_ARTICOLO'] == 'ASSENTE' || ( ! empty( $stato['articoli'] ) && ! isset( $stato['articoli'][ $riga['RIG_ARTICOLO'] ] ) ) ) {
                    rifiuta( 'Riga Ordine - Violata integrita\' articolo !', $ordine, $riga );
                }
                $chiave = ( ! empty( $riga['RIG_HOSTINF'] ) ) ? $riga['RIG_HOSTINF'] : count( $ordini[ $codice ]['righe'] ) . '-' . $n;
                $ordini[ $codice ]['righe'][ $chiave ] = $riga;
            }

        }

        $stato['ordini'] = $ordini;
        rispondi( 200, 'Operazione completata con successo' );

    }

    // export
    if( $metodo == 'GET' ) {

        // un pacchetto non confermato si ripete
        if( empty( $stato['pacchetti'][ $job[1] ] ) ) {

            // giacenze
            if( strpos( $job[1], 'GIACENZE' ) !== false ) {

                if( empty( $stato['giacenze'] ) ) {
                    rispondi( 204 );
                }

                $dati = array( 'EXP_GIACENZE' => array() );
                foreach( $stato['giacenze'] as $codice => $quantita ) {
                    $dati['EXP_GIACENZE'][] = array(
                        'GIA_DATAORAS1' => date( 'Y-m-d H:i:s' ), 'GIA_ARTICOLO' => (string) $codice,
                        'GIA_GIAC' => $quantita, 'GIA_VER' => 0, 'GIA_PRE' => 0
                    );
                }
                $resto = 0;

            // stato di ordini e righe
            } else {

                if( empty( $stato['ordini'] ) ) {
                    rispondi( 204 );
                }

                // alla lettura il finto esegue gli ordini in attesa: ogni riga completata, tranne quelle
                // dell'articolo MANCA ( incompleta a zero ), PARZIALE ( incompleta a meta' ), ATTESA ( resta
                // in attesa, con l'ordine ) e LANCIATO ( in esecuzione, con l'ordine )
                $dati = array( 'EXP_ORDINI' => array(), 'EXP_ORDINI_RIGHE' => array() );
                foreach( array_slice( array_keys( $stato['ordini'] ), 0, $pacchettoMax ) as $codice ) {
                    $ordine = &$stato['ordini'][ $codice ];
                    $testata = 'COMPL';
                    foreach( $ordine['righe'] as &$riga ) {
                        $richiesta = (float) str_replace( ',', '.', $riga['RIG_QTAR'] );
                        if( $riga['RIG_ARTICOLO'] == 'ATTESA' ) {
                            $testata = 'WAIT'; $riga['RIG_STARIORD'] = 'W'; $evasa = 0;
                        } elseif( $riga['RIG_ARTICOLO'] == 'LANCIATO' ) {
                            $testata = 'EXE'; $riga['RIG_STARIORD'] = 'E'; $evasa = 0;
                        } elseif( $riga['RIG_ARTICOLO'] == 'MANCA' ) {
                            $riga['RIG_STARIORD'] = 'I'; $evasa = 0;
                        } elseif( $riga['RIG_ARTICOLO'] == 'PARZIALE' ) {
                            $riga['RIG_STARIORD'] = 'I'; $evasa = floor( $richiesta / 2 );
                        } elseif( isset( $riga['RIG_HOSTINF'], $stato['evasioni'][ $riga['RIG_HOSTINF'] ] ) ) {
                            $evasa = min( $richiesta, (float) $stato['evasioni'][ $riga['RIG_HOSTINF'] ] );
                            $riga['RIG_STARIORD'] = ( $evasa < $richiesta ) ? 'I' : 'C';
                        } else {
                            $riga['RIG_STARIORD'] = 'C'; $evasa = $richiesta;
                        }
                        $riga['RIG_QTAE'] = number_format( $evasa, 3, ',', '' );
                        $riga['RIG_EXE_OPERATORE'] = ( $evasa > 0 ) ? 'FINTO' : '';
                        $riga['RIG_DMOV1'] = date( 'Y-m-d H:i:s' );
                        $dati['EXP_ORDINI_RIGHE'][] = $riga;
                    }
                    unset( $riga );
                    $ordine['ordine']['ORD_STATO'] = $testata;
                    $dati['EXP_ORDINI'][] = $ordine['ordine'];
                    unset( $ordine );
                }
                $resto = count( $stato['ordini'] ) - $pacchettoMax;

            }

            $stato['pacchetti'][ $job[1] ] = array(
                'GUID' => vsprintf( '%s%s-%s-%s-%s-%s%s%s', str_split( bin2hex( random_bytes( 16 ) ), 4 ) ),
                'DATA' => $dati,
                'TransactionStatus' => ( $resto > 0 ) ? 'CHUNK' : 'END'
            );

        }

        rispondi( 200, $stato['pacchetti'][ $job[1] ] );

    }

    rispondi( 405, 'Method Not Allowed' );
