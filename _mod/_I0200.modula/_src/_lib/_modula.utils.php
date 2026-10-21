<?php

    /**
     * libreria per lo scambio di ordini col WMS Modula tramite il protocollo WebService
     *
     * Il WMS Modula espone i suoi job con il protocollo WebService 1.11: per ogni job configurato in modalita'
     * server risponde su {url}/api/jobs/{job}, e il gestionale fa da client. Il giro di un ordine e' questo:
     *
     * - modulaImport() manda in POST gli ordini e le loro righe al job di import, e il WMS risponde 200 se li ha
     *   accettati, un altro codice con la descrizione dell'errore se no;
     * - modulaExport() scarica in GET dal job di export un pacchetto di esiti ( EXP_ORDINI ed EXP_ORDINI_RIGHE,
     *   con la quantita' evasa in RIG_QTAE ), identificato da un GUID; a vuoto il WMS non manda nulla;
     * - modulaAck() conferma il pacchetto col suo GUID: solo allora il WMS manda il successivo, e il pacchetto
     *   confermato non si puo' piu' richiedere. Quindi l'ack si manda DOPO aver scritto gli esiti, mai prima:
     *   se la scrittura fallisce, alla chiamata dopo il WMS ripete lo stesso pacchetto.
     *
     * Le quantita' viaggiano come testo con la virgola e tre decimali ( "1,000" ): la conversione si fa con
     * modulaQta2Testo() e modulaTesto2Qta(), non a mano.
     *
     * L'autenticazione e' Basic oppure Bearer, secondo modula.profiles.<PROFILO>.auth. In Bearer il token si
     * chiede a {url}/token e si tiene in memcache fino a un minuto prima della scadenza; se il WMS risponde 401
     * lo si richiede e la chiamata si ripete una volta sola.
     *
     * La configurazione e' in _src/_config/_030.common.php; il server finto per i test, che risponde come il
     * WMS, e' in _usr/_test/_fake/_wms.php.
     *
     * vedi:
     * - "Job con protocollo WebService 1.11", Modula ( documentazione del fornitore )
     *
     */

    /**
     * chiave memcache del token Bearer
     */
    define( 'MODULA_TOKEN', 'MODULA_TOKEN' );

    /**
     * funzione che converte una quantita' nel formato testo del WMS
     *
     * @param    float     q    la quantita'
     *
     * @return   string         la quantita' con la virgola e tre decimali, p.es. "1,000"
     */
    function modulaQta2Testo( $q ) {

        return number_format( (float) $q, 3, ',', '' );

    }

    /**
     * funzione che converte una quantita' dal formato testo del WMS
     *
     * @param    string    t    la quantita' col separatore decimale a virgola, p.es. "1,000"
     *
     * @return   float          la quantita'
     */
    function modulaTesto2Qta( $t ) {

        return (float) str_replace( ',', '.', str_replace( '.', '', trim( $t ) ) );

    }

    /**
     * funzione che restituisce il token Bearer del WMS
     *
     * Il token dura un giorno ( expires_in ): lo si tiene in memcache fino a un minuto prima della scadenza, cosi'
     * le chiamate di un task non chiedono un token a testa. Con $rinnova lo si richiede anche se in cache c'e',
     * ed e' quello che si fa quando il WMS risponde 401 a un token che per noi era ancora buono.
     *
     * @param    boolean   rinnova    true per ignorare la cache
     *
     * @return   string               il token, NULL se il WMS non lo concede
     */
    function modulaToken( $rinnova = false ) {

        // globalizzazione
        global $cf;

        // profilo corrente
        $p = $cf['modula']['profile'];

        // token in cache
        if( ! $rinnova ) {
            $token = memcacheRead( $cf['memcache']['connection'], MODULA_TOKEN );
            if( ! empty( $token ) ) {
                return $token;
            }
        }

        // richiesta del token
        $risposta = restCall(
            rtrim( $p['url'], '/' ) . '/token',
            METHOD_POST,
            array( 'grant_type' => 'password', 'username' => $p['username'], 'password' => $p['password'] ),
            MIME_X_WWW_FORM_URLENCODED,
            MIME_APPLICATION_JSON,
            $status, array(), NULL, NULL, $errore, NULL, CURLAUTH_BASIC, $raw, $intestazioni, $p['timeout']
        );

        if( $status != 200 || empty( $risposta['access_token'] ) ) {
            logger( 'token negato dal WMS ( ' . $status . ' ): ' . $raw . ' ' . $errore, 'modula', LOG_ERR );
            return NULL;
        }

        // scadenza un minuto prima di quella dichiarata
        $ttl = ( isset( $risposta['expires_in'] ) ) ? max( 60, (int) $risposta['expires_in'] - 60 ) : 3600;
        memcacheWrite( $cf['memcache']['connection'], MODULA_TOKEN, $risposta['access_token'], $ttl );

        return $risposta['access_token'];

    }

    /**
     * funzione che fa una chiamata al WMS
     *
     * Costruisce l'URL dal profilo corrente, applica l'autenticazione configurata e, in Bearer, su un 401 rinnova
     * il token e ripete la chiamata una volta.
     *
     * @param    string    percorso    il percorso dopo l'URL di base, p.es. /api/jobs/CFG-IMP-ORDINI
     * @param    string    metodo      METHOD_GET oppure METHOD_POST
     * @param    array     dati        il corpo, mandato come JSON
     * @param    int       status      il codice HTTP della risposta
     * @param    string    raw         la risposta grezza, che negli errori e' la descrizione del WMS
     *
     * @return   array                 la risposta decodificata, NULL se vuota o se il modulo non e' configurato
     */
    function modulaChiamata( $percorso, $metodo = METHOD_GET, $dati = NULL, &$status = NULL, &$raw = NULL ) {

        // globalizzazione
        global $cf;

        // profilo corrente
        $p = $cf['modula']['profile'];

        // senza URL il modulo e' spento
        if( empty( $p['url'] ) ) {
            logger( 'URL del WMS non configurato per il profilo ' . SITE_STATUS, 'modula', LOG_WARNING );
            $status = NULL;
            return NULL;
        }

        // due tentativi al massimo: il secondo solo per un token scaduto
        for( $tentativo = 0; $tentativo < 2; $tentativo++ ) {

            if( $p['auth'] == 'basic' ) {
                $user = $p['username']; $pasw = $p['password']; $token = NULL;
            } else {
                $user = NULL; $pasw = NULL; $token = modulaToken( $tentativo > 0 );
                if( empty( $token ) ) {
                    $status = 401;
                    return NULL;
                }
            }

            $risposta = restCall(
                rtrim( $p['url'], '/' ) . $percorso,
                $metodo, $dati,
                MIME_APPLICATION_JSON, MIME_APPLICATION_JSON,
                $status, array(), $user, $pasw, $errore, $token, CURLAUTH_BASIC, $raw, $intestazioni, $p['timeout']
            );

            if( $status != 401 || $p['auth'] == 'basic' ) {
                break;
            }

        }

        if( $status < 200 || $status > 299 ) {
            logger( $metodo . ' ' . $percorso . ' -> ' . $status . ': ' . $raw . ' ' . $errore, 'modula', LOG_ERR );
        }

        return $risposta;

    }

    /**
     * funzione che manda degli ordini al job di import del WMS
     *
     * Gli ordini e le righe vanno nei formati delle tabelle host IMP_ORDINI e IMP_ORDINI_RIGHE, con le quantita'
     * gia' convertite da modulaQta2Testo(), p.es.
     *
     *     modulaImport(
     *         array( array( 'ORD_ORDINE' => 'LP-1', 'ORD_DES' => 'lista 1', 'ORD_TIPOOP' => 'P' ) ),
     *         array( array( 'RIG_ORDINE' => 'LP-1', 'RIG_ARTICOLO' => 'A1', 'RIG_QTAR' => '1,000' ) )
     *     );
     *
     * @param    array     ordini     le righe di IMP_ORDINI
     * @param    array     righe      le righe di IMP_ORDINI_RIGHE
     * @param    string    job        il job, di default quello di import del profilo
     * @param    string    errore     la descrizione dell'errore restituita dal WMS
     *
     * @return   boolean              true solo se il WMS ha risposto 200
     */
    function modulaImport( $ordini, $righe, $job = NULL, &$errore = NULL ) {

        // globalizzazione
        global $cf;

        // job di default
        if( empty( $job ) ) {
            $job = $cf['modula']['profile']['jobs']['import'];
        }

        modulaChiamata(
            '/api/jobs/' . rawurlencode( $job ),
            METHOD_POST,
            array( 'IMP_ORDINI' => array_values( $ordini ), 'IMP_ORDINI_RIGHE' => array_values( $righe ) ),
            $status, $raw
        );

        if( $status != 200 ) {
            $errore = $status . ' ' . $raw;
            return false;
        }

        $errore = NULL;
        return true;

    }

    /**
     * funzione che scarica un pacchetto di esiti dal job di export del WMS
     *
     * Restituisce il pacchetto com'e', p.es.
     *
     *     array(
     *         'GUID' => '…', 'TransactionStatus' => 'CHUNK',
     *         'DATA' => array( 'EXP_ORDINI' => array( … ), 'EXP_ORDINI_RIGHE' => array( … ) )
     *     )
     *
     * TransactionStatus vale CHUNK se ci sono altri pacchetti dopo questo, END se e' l'ultimo. Il pacchetto va
     * confermato con modulaAck() dopo averne scritto gli esiti: finche' non lo si conferma il WMS ripete lo stesso.
     *
     * @param    string    job        il job, di default quello di export del profilo
     * @param    int       status     il codice HTTP della risposta
     *
     * @return   array                il pacchetto, NULL se non c'e' niente da scaricare o in caso di errore
     */
    function modulaExport( $job = NULL, &$status = NULL ) {

        // globalizzazione
        global $cf;

        // job di default
        if( empty( $job ) ) {
            $job = $cf['modula']['profile']['jobs']['export'];
        }

        $pacchetto = modulaChiamata( '/api/jobs/' . rawurlencode( $job ), METHOD_GET, NULL, $status, $raw );

        if( $status != 200 || empty( $pacchetto['GUID'] ) ) {
            return NULL;
        }

        return $pacchetto;

    }

    /**
     * funzione che conferma al WMS un pacchetto di esiti
     *
     * @param    string    guid       il GUID del pacchetto restituito da modulaExport()
     * @param    string    job        il job, di default quello di export del profilo
     *
     * @return   boolean              true se il WMS ha accettato la conferma
     */
    function modulaAck( $guid, $job = NULL ) {

        // globalizzazione
        global $cf;

        // job di default
        if( empty( $job ) ) {
            $job = $cf['modula']['profile']['jobs']['export'];
        }

        modulaChiamata( '/api/jobs/' . rawurlencode( $job ) . '/ack', METHOD_POST, array( 'GUID' => $guid ), $status, $raw );

        return ( $status == 200 );

    }
