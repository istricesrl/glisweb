<?php

    /**
     * libreria per la verifica degli indirizzi mail tramite Emailable
     *
     * Emailable si usa in due modi, e questa libreria li serve tutti e due:
     *
     * - un indirizzo alla volta, quando un utente compila un form: lo snippet
     *   _src/_twig/_inc/_emailable.close.twig ( e il gemello legacy _src/_html/_inc/_emailable.close.html )
     *   sul blur del campo chiama _src/_api/_emailable.verifica.php, che risponde dalla cache se il
     *   verdetto c'e' e altrimenti interroga /v1/verify con emailableVerifyOne();
     * - in blocco, per verificare migliaia di indirizzi insieme ( p.es. un'esportazione ): qui si usa
     *   l'API batch, una chiamata sola piu' un polling sull'id restituito, con emailableVerifyStart()
     *   ed emailableVerifyResult().
     *
     * I verdetti vengono messi in cache nella tabella `mail_status`, chiavata sull'indirizzo, cosi'
     * si paga una verifica per indirizzo e non una per richiesta. La scadenza della cache e'
     * configurabile sotto emailable.profiles.<PROFILO>.ttl ( default sei mesi ). Sui deploy dove la
     * tabella non esiste ancora le letture tornano vuote e le scritture falliscono in silenzio: la
     * verifica funziona lo stesso, solo senza cache.
     *
     * I principi operativi sono gli stessi del client e non vanno cambiati:
     * - fail-open: se il servizio non risponde, e' in quota esaurita o restituisce un errore,
     *   l'indirizzo NON viene bocciato e l'elaborazione prosegue;
     * - si boccia solo sulla prova esplicita di non recapitabilita' ( state 'undeliverable' );
     *   'risky' e 'unknown' passano, perche' i server Yahoo/Outlook marcano spesso come
     *   rischiose caselle validissime.
     *
     * vedi:
     * - https://emailable.com/docs/api/#batch-verification
     * - https://emailable.com/docs/api/#verify-an-email
     *
     */

    /**
     * funzione che restituisce la chiave Emailable da usare per le chiamate server-to-server
     *
     * Le chiavi Emailable sono di due tipi e NON sono intercambiabili:
     *
     * - `apikey` e' la chiave client-side, ristretta ai trusted domains configurati nel pannello.
     *   La usa lo snippet JS ( _src/_twig/_inc/_emailable.close.twig ), a cui il browser mette
     *   l'header Origin da solo. Da server risponde 403 a /v1/batch e /v1/account anche mandando
     *   un Referer valido: e' abilitata al solo /v1/verify.
     * - `apikey_server` e' la chiave server-side, senza restrizione di dominio, ed e' l'unica che
     *   puo' usare le API batch.
     *
     * Il fallback su `apikey` serve solo a non rompere un deploy dove la chiave server non e'
     * ancora stata censita: li' il batch fallira' con 403 e il job chiudera' in fail-open, che e'
     * il comportamento voluto ( meglio l'esportazione senza verdetti che nessuna esportazione ).
     *
     * @return    chiave da usare, NULL se non configurata
     */
    function emailableApiKey() {

        // globalizzazione
        global $cf;

        if( ! empty( $cf['emailable']['profile']['apikey_server'] ) ) {
            return $cf['emailable']['profile']['apikey_server'];
        }

        if( ! empty( $cf['emailable']['profile']['apikey'] ) ) {
            logger( 'chiave Emailable server mancante, ripiego sulla client-side: il batch fallira con 403', 'emailable', LOG_WARNING );
            return $cf['emailable']['profile']['apikey'];
        }

        return NULL;

    }

    /**
     * funzione che traduce lo stato restituito da Emailable in una tipologia di mail_status
     *
     * Le tipologie sono una scala di verifica mail ( Rating A+/A/B/D/F ) diffusa fra i gestionali
     * di mailing, e gli id sono fissati dalla patch che le crea: la traduzione e' quindi una
     * corrispondenza uno a uno, non una convenzione inventata qui. Vedi la patch
     * _usr/_database/_patch/_202609231600.mail.status.sql per il perche'.
     *
     * @param    string    s    stato restituito da Emailable ( campo 'state' )
     * @param    bool      a    valore del campo 'accept_all' restituito da Emailable
     *
     * @return                  id della tipologia in tipologie_mail_status, NULL se ignoto
     */
    function emailableState2status( $s, $a = NULL ) {

        // un server che accetta qualunque indirizzo non dice niente sul singolo indirizzo:
        // la scala lo classifica Rating B ( Accepts All ) a prescindere dallo stato
        if( ! empty( $a ) ) {
            return 3;
        }

        switch( strtolower( trim( (string) $s ) ) ) {

            // deliverable -> Rating A
            case 'deliverable':
                return 2;

            // risky -> Rating B, il server accetta ma puo' rimbalzare
            case 'risky':
                return 3;

            // unknown -> Rating D, la verifica non ha concluso
            case 'unknown':
                return 4;

            // undeliverable -> Rating F, l'unico caso in cui si boccia
            case 'undeliverable':
                return 5;

        }

        // stato non riconosciuto: non si inventa un verdetto
        return NULL;

    }

    /**
     * funzione che accoda un blocco di indirizzi alla verifica batch di Emailable
     *
     * @param    array     a       indirizzi da verificare
     * @param    string    esito   [out] motivo dell'esito
     *
     * @return                     id del batch accettato da Emailable, NULL in caso di errore
     */
    function emailableVerifyStart( $a, &$esito = NULL ) {

        // globalizzazione
        global $cf;

        // senza chiave non si va da nessuna parte
        if( empty( emailableApiKey() ) ) {
            logger( 'chiave Emailable server non configurata per il profilo ' . SITE_STATUS, 'emailable', LOG_ERR );
            $esito = 'chiave mancante';
            return NULL;
        }

        // niente da verificare
        if( empty( $a ) ) {
            $esito = 'nessun indirizzo';
            return NULL;
        }

        $dati = array(
            'api_key' => emailableApiKey(),
            'emails'  => implode( ',', $a )
        );

        $r = restCall( 'https://api.emailable.com/v1/batch', METHOD_POST, $dati, MIME_X_WWW_FORM_URLENCODED, MIME_APPLICATION_JSON, $status );

        if( isset( $r['id'] ) ) {

            // caso normale: Emailable ha accettato il blocco
            logger( 'batch ' . $r['id'] . ' accettato per ' . count( $a ) . ' indirizzi', 'emailable' );
            $esito = 'accettato';
            return $r['id'];

        }

        // qualunque altro caso e' un disservizio: rete, quota, chiave, 5xx. Non e' un verdetto
        // sugli indirizzi e non deve diventarlo ( fail-open )
        logger( 'batch non accettato ( http ' . $status . ' ): ' . serialize( $r ), 'emailable', LOG_ERR );
        $esito = ( isset( $r['message'] ) ) ? $r['message'] : 'nessuna risposta';

        return NULL;

    }

    /**
     * funzione che legge l'esito di una verifica batch di Emailable
     *
     * Emailable risponde alla stessa URL in due modi: finche' sta lavorando restituisce un
     * messaggio con i contatori 'processed' e 'total', a lavoro finito restituisce l'array
     * 'emails' con un elemento per indirizzo. Il chiamante distingue i due casi dal valore
     * di ritorno: NULL vuol dire "non ancora pronto", un array vuol dire "ecco i risultati".
     *
     * @param    string    i       id del batch
     * @param    string    esito   [out] motivo dell'esito
     *
     * @return                     array dei risultati, NULL se il batch non e' ancora pronto
     */
    function emailableVerifyResult( $i, &$esito = NULL ) {

        // globalizzazione
        global $cf;

        if( empty( emailableApiKey() ) || empty( $i ) ) {
            $esito = 'chiave o batch mancanti';
            return NULL;
        }

        $dati = array(
            'api_key' => emailableApiKey(),
            'id'      => $i
        );

        $r = restCall( 'https://api.emailable.com/v1/batch', METHOD_GET, $dati, 'query', MIME_APPLICATION_JSON, $status );

        if( isset( $r['emails'] ) && is_array( $r['emails'] ) ) {

            // batch completato, risposta breve: i verdetti sono nel corpo
            logger( 'batch ' . $i . ' completato con ' . count( $r['emails'] ) . ' risultati', 'emailable' );
            $esito = 'completato';
            return $r['emails'];

        }

        /**
         * batch completato, risposta lunga: i verdetti stanno in un CSV zippato
         *
         * Sopra una certa dimensione Emailable non mette piu' i risultati nel corpo della
         * risposta: manda 'download_file' con l'URL di uno zip. Il codice conosceva solo la
         * forma breve, quindi un batch grosso e **completato** cadeva nel ramo finale come
         * "nessun esito", il job lo leggeva come "non ancora pronto" e continuava ad aspettare
         * fino a esaurire le iterazioni: il file usciva senza verdetti e con tre colonne vuote,
         * senza che niente lo segnalasse.
         *
         * Successo il 14/09/2026 a due esportazioni nello stesso pomeriggio ( 2.466 e 17.621
         * indirizzi ), mentre altre andavano bene perche' li' la cache copriva quasi tutto e i
         * pochi rimasti stavano nella risposta breve.
         *
         * L'URL e' firmato e scade in un'ora: si scarica subito, si legge e si butta.
         */
        if( ! empty( $r['download_file'] ) ) {

            $righe = emailableBatchCsv( $r['download_file'], $i );

            if( is_array( $righe ) ) {

                logger( 'batch ' . $i . ' completato con ' . count( $righe ) . ' risultati ( da download_file )', 'emailable' );
                $esito = 'completato';
                return $righe;

            }

            // lo zip c'e' ma non si e' riusciti a leggerlo: e' un errore, non un'attesa
            logger( 'batch ' . $i . ' completato ma il file dei risultati non e\' leggibile', 'emailable', LOG_ERR );
            $esito = 'risultati non leggibili';

            return NULL;

        }

        if( isset( $r['processed'] ) ) {

            // ancora in lavorazione, il chiamante ripassera'
            logger( 'batch ' . $i . ' in lavorazione: ' . $r['processed'] . '/' . ( isset( $r['total'] ) ? $r['total'] : '?' ), 'emailable' );
            $esito = 'in lavorazione';
            return NULL;

        }

        // disservizio: si logga e si lascia decidere al chiamante quando smettere di aspettare
        logger( 'nessun esito per il batch ' . $i . ' ( http ' . $status . ' ): ' . serialize( $r ), 'emailable', LOG_ERR );
        $esito = ( isset( $r['message'] ) ) ? $r['message'] : 'nessuna risposta';

        return NULL;

    }

    /**
     * funzione che scarica e legge il CSV zippato dei risultati di un batch Emailable
     *
     * Restituisce le righe nella stessa forma in cui Emailable le manda quando le mette nel
     * corpo della risposta ( chiavi email, state, reason, score, accept_all, ... ), cosi' il
     * chiamante non deve sapere da quale delle due strade sono arrivate e mailStatusWrite()
     * funziona con tutte e due senza modifiche.
     *
     * Il file di appoggio sta in var/spool/emailable/ e viene cancellato sempre, anche quando
     * la lettura fallisce: contiene indirizzi di persone e non e' roba da lasciare in giro.
     *
     * @param    string    url    URL firmato del download, come arriva in 'download_file'
     * @param    string    id     id del batch, per i messaggi di log
     *
     * @return                    array delle righe, NULL se non si e' potuto leggere
     */
    function emailableBatchCsv( $url, $id ) {

        $dir = DIR_VAR_SPOOL . 'emailable/';

        if( ! checkPath( $dir ) ) {
            logger( 'non riesco a creare ' . $dir, 'emailable', LOG_ERR );
            return NULL;
        }

        $zip = $dir . 'batch.' . preg_replace( '/[^a-zA-Z0-9]/', '', (string) $id ) . '.zip';
        $csv = NULL;

        // lo scarico ha un timeout suo: il file puo' essere di qualche megabyte
        $ctx = stream_context_create( array( 'http' => array( 'timeout' => 120 ) ) );
        $dati = @file_get_contents( $url, false, $ctx );

        if( $dati === false || $dati === '' ) {
            logger( 'scarico dei risultati del batch ' . $id . ' non riuscito', 'emailable', LOG_ERR );
            return NULL;
        }

        file_put_contents( $zip, $dati );

        $righe = NULL;
        $za = new ZipArchive();

        if( $za->open( $zip ) === true ) {

            // nello zip c'e' un CSV solo
            for( $k = 0; $k < $za->numFiles; $k++ ) {

                $nome = $za->getNameIndex( $k );

                if( substr( strtolower( $nome ), -4 ) !== '.csv' ) { continue; }

                $testo = $za->getFromIndex( $k );

                if( $testo === false || $testo === '' ) { continue; }

                $csv = explode( "\n", str_replace( "\r\n", "\n", $testo ) );
                break;

            }

            $za->close();

        } else {
            logger( 'lo zip dei risultati del batch ' . $id . ' non si apre', 'emailable', LOG_ERR );
        }

        // il file di appoggio non resta in giro in nessun caso
        @unlink( $zip );

        if( empty( $csv ) ) {
            return NULL;
        }

        // prima riga: intestazione. Le chiavi si normalizzano come quelle della risposta breve
        $intestazione = str_getcsv( array_shift( $csv ) );

        foreach( $intestazione as $c => $nome ) {
            $intestazione[ $c ] = strtolower( trim( str_replace( ' ', '_', $nome ) ) );
        }

        $righe = array();

        foreach( $csv as $r ) {

            if( trim( $r ) === '' ) { continue; }

            $v = str_getcsv( $r );
            $e = array();

            foreach( $intestazione as $c => $nome ) {
                $e[ $nome ] = ( isset( $v[ $c ] ) ) ? $v[ $c ] : NULL;
            }

            // nel CSV i booleani sono le stringhe "true"/"false"
            foreach( array( 'accept_all', 'disposable', 'free', 'role' ) as $b ) {
                if( isset( $e[ $b ] ) ) {
                    $e[ $b ] = ( strtolower( trim( (string) $e[ $b ] ) ) === 'true' ) ? 1 : 0;
                }
            }

            if( ! empty( $e['email'] ) ) {
                $righe[] = $e;
            }

        }

        return ( count( $righe ) ) ? $righe : NULL;

    }

    /**
     * funzione che verifica un solo indirizzo con l'endpoint sincrono di Emailable
     *
     * Serve perche' /v1/batch RIFIUTA i blocchi da un indirizzo solo, rispondendo "Please send
     * more than one email". Non e' un caso di scuola: succede ogni volta che la cache copre
     * tutto il blocco tranne un indirizzo ( visto su un'esportazione da 25.583 indirizzi distinti,
     * uno solo da verificare, rimasto senza verdetto ). E' anche la funzione che serve la verifica
     * dai form, un indirizzo alla volta, tramite _src/_api/_emailable.verifica.php.
     *
     * /v1/verify risponde in linea, quindi qui non c'e' polling: o torna il verdetto, o non
     * torna niente. La risposta ha la stessa forma di un elemento dell'array 'emails' del
     * batch, quindi il chiamante puo' passarla a mailStatusWrite() cosi' com'e'.
     *
     * Vale il fail-open di tutta la libreria: qualunque disservizio restituisce NULL e
     * l'indirizzo resta senza verdetto, non bocciato.
     *
     * @param    string    e       indirizzo da verificare
     * @param    string    esito   [out] motivo dell'esito
     *
     * @return                     riga del verdetto, NULL in caso di errore
     */
    function emailableVerifyOne( $e, &$esito = NULL ) {

        // globalizzazione
        global $cf;

        if( empty( emailableApiKey() ) || empty( $e ) ) {
            $esito = 'chiave o indirizzo mancanti';
            return NULL;
        }

        $dati = array(
            'api_key' => emailableApiKey(),
            'email'   => $e
        );

        // la chiave client-side e' ristretta ai trusted domains del pannello Emailable e da server
        // risponde 403 se manca l'Origin, che il browser mette da solo e curl no: lo si manda qui,
        // cosi' la verifica singola funziona anche sui deploy che hanno censito solo quella
        $headers = array();
        if( ! empty( $cf['site']['url'] ) ) {
            $headers['Origin']  = rtrim( $cf['site']['url'], '/' );
            $headers['Referer'] = $cf['site']['url'];
        }

        $r = restCall( 'https://api.emailable.com/v1/verify', METHOD_GET, $dati, 'query', MIME_APPLICATION_JSON, $status, $headers );

        if( isset( $r['state'] ) ) {

            // caso normale: Emailable ha concluso
            logger( 'verifica singola di ' . $e . ': ' . $r['state'], 'emailable' );
            $esito = 'verificato';

            // /v1/verify puo' omettere 'email' nella risposta, mentre mailStatusWrite() la usa
            // come chiave: la si rimette qui invece di renderla opzionale la' dentro
            if( empty( $r['email'] ) ) {
                $r['email'] = $e;
            }

            return $r;

        }

        // disservizio, compreso il 249 con cui Emailable dice "riprova": fail-open
        logger( 'verifica singola di ' . $e . ' non conclusa ( http ' . $status . ' ): ' . serialize( $r ), 'emailable', LOG_ERR );
        $esito = ( isset( $r['message'] ) ) ? $r['message'] : 'nessuna risposta';

        return NULL;

    }

    /**
     * funzione che legge dalla cache i verdetti ancora validi per un elenco di indirizzi
     *
     * @param    array    a    indirizzi da cercare
     * @param    int      t    scadenza in secondi, se NULL si usa quella del profilo
     *
     * @return                 array indirizzo => riga di mail_status
     */
    function mailStatusRead( $a, $t = NULL ) {

        // globalizzazione
        global $cf;

        $r = array();

        if( empty( $a ) ) {
            return $r;
        }

        // scadenza: parametro, poi configurazione, poi sei mesi
        if( $t === NULL ) {
            $t = ( isset( $cf['emailable']['profile']['ttl'] ) ) ? $cf['emailable']['profile']['ttl'] : 15552000;
        }

        // gli indirizzi sono normalizzati in minuscolo in scrittura, si cercano cosi'
        $a = array_values( array_unique( array_map( 'mailStatusNormalize', $a ) ) );

        // segnaposto per la IN, uno per indirizzo
        $p = array( array( 's' => time() - $t ) );

        foreach( $a as $i ) {
            $p[] = array( 's' => $i );
        }

        $q = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT ms.*, t.se_recapitabile, t.nome AS stato_nome FROM mail_status AS ms '
            .'LEFT JOIN tipologie_mail_status AS t ON t.id = ms.id_tipologia '
            .'WHERE ms.timestamp_verifica IS NOT NULL AND ms.timestamp_verifica >= ? '
            .'AND ms.indirizzo IN ( ' . implode( ', ', array_fill( 0, count( $a ), '?' ) ) . ' )',
            $p
        );

        if( ! empty( $q ) ) {
            foreach( $q as $riga ) {
                $r[ $riga['indirizzo'] ] = $riga;
            }
        }

        return $r;

    }

    /**
     * funzione che scrive in cache il verdetto di un indirizzo
     *
     * L'INSERT ... ON DUPLICATE KEY UPDATE si appoggia all'indice unico su mail_status.indirizzo:
     * un indirizzo ha un verdetto solo, e riverificarlo lo aggiorna invece di duplicarlo.
     *
     * @param    array    e    elemento restituito da Emailable per un indirizzo
     *
     * @return                esito della query
     */
    function mailStatusWrite( $e ) {

        // globalizzazione
        global $cf;

        if( empty( $e['email'] ) ) {
            return false;
        }

        $indirizzo = mailStatusNormalize( $e['email'] );

        $accept_all = ( isset( $e['accept_all'] ) ) ? ( ( $e['accept_all'] ) ? 1 : 0 ) : NULL;

        return mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO mail_status ( indirizzo, dominio, id_tipologia, stato, motivo, punteggio, se_accept_all, se_ruolo, '
            .'se_temporanea, se_gratuita, tentativi, timestamp_verifica, timestamp_inserimento ) '
            .'VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, ?, ? ) '
            .'ON DUPLICATE KEY UPDATE dominio = VALUES( dominio ), id_tipologia = VALUES( id_tipologia ), stato = VALUES( stato ), '
            .'motivo = VALUES( motivo ), punteggio = VALUES( punteggio ), se_accept_all = VALUES( se_accept_all ), '
            .'se_ruolo = VALUES( se_ruolo ), se_temporanea = VALUES( se_temporanea ), se_gratuita = VALUES( se_gratuita ), '
            .'tentativi = tentativi + 1, timestamp_verifica = VALUES( timestamp_verifica ), '
            .'timestamp_aggiornamento = VALUES( timestamp_verifica )',
            array(
                array( 's' => $indirizzo ),
                array( 's' => ( isset( $e['domain'] ) ) ? $e['domain'] : substr( strrchr( $indirizzo, '@' ), 1 ) ),
                array( 's' => emailableState2status( ( isset( $e['state'] ) ) ? $e['state'] : NULL, $accept_all ) ),
                array( 's' => ( isset( $e['state'] ) ) ? $e['state'] : NULL ),
                array( 's' => ( isset( $e['reason'] ) ) ? $e['reason'] : NULL ),
                array( 's' => ( isset( $e['score'] ) ) ? $e['score'] : NULL ),
                array( 's' => $accept_all ),
                array( 's' => ( isset( $e['role'] ) ) ? ( ( $e['role'] ) ? 1 : 0 ) : NULL ),
                array( 's' => ( isset( $e['disposable'] ) ) ? ( ( $e['disposable'] ) ? 1 : 0 ) : NULL ),
                array( 's' => ( isset( $e['free'] ) ) ? ( ( $e['free'] ) ? 1 : 0 ) : NULL ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

    }

    /**
     * funzione che normalizza un indirizzo mail per l'uso come chiave di cache
     *
     * @param    string    i    indirizzo
     *
     * @return                  indirizzo normalizzato
     */
    function mailStatusNormalize( $i ) {

        return strtolower( trim( (string) $i ) );

    }
