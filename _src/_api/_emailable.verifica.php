<?php

    /**
     * endpoint di verifica di un indirizzo mail con Emailable, con cache dei verdetti
     *
     * Chiamato in POST (JSON) da _src/_twig/_inc/_emailable.close.twig ( e dal gemello legacy
     * _src/_html/_inc/_emailable.close.html ) sul blur dei campi email dei form, con il corpo
     * { "email": "<indirizzo>" }. Risponde con i campi di Emailable che servono allo snippet:
     *
     *     { "status": "OK", "cache": true|false, "state": "...", "reason": "...", "score": ..., "accept_all": ..., "did_you_mean": ... }
     *
     * Il browser non parla piu' con Emailable direttamente, e per tre motivi:
     *
     * - la verifica finisce in cache in `mail_status`, e il verdetto che ci finisce lo ottiene il
     *   server: se fosse il browser a mandarlo, chiunque potrebbe scrivere in cache un
     *   'undeliverable' falso e far sparire un indirizzo buono da ogni invio;
     * - lo stesso indirizzo verificato su piu' form, o riprovato dallo stesso utente, si paga una
     *   volta sola per tutta la durata della cache ( emailable.profiles.<PROFILO>.ttl );
     * - la chiave Emailable non sta piu' scritta nel JavaScript della pagina.
     *
     * L'endpoint e' pubblico ( i form lo sono ), quindi ogni verifica pagata e' una richiesta che
     * chiunque puo' fare: per questo passa dal limitatore del firewall, rateLimitCheck(), con un
     * tetto per IP configurabile in emailable.profiles.<PROFILO>.limite ( richieste e finestra in
     * secondi, default 30 all'ora ).
     *
     * Vale il fail-open dello snippet: ogni esito diverso da 200 con status OK ( indirizzo
     * malformato, limite superato, Emailable che non risponde ) viene letto dal browser come
     * "non verificato", e il form parte lo stesso.
     *
     */

    // inclusione del framework
    if( ! defined( 'INCLUDE_SUBDIR' ) ) {
        require '../_config.php';
    } else {
        require INCLUDE_SUBDIR . '_config.php';
    }

    // dati in ingresso
    $data   = json_decode( file_get_contents( 'php://input' ), true );
    $result = array( 'status' => 'KO' );

    // indirizzo da verificare, normalizzato come la chiave della cache
    $email = ( is_array( $data ) && isset( $data['email'] ) ) ? mailStatusNormalize( substr( (string) $data['email'], 0, 254 ) ) : '';

    // limite di frequenza per IP
    $limite = array(
        'richieste' => ( isset( $cf['emailable']['profile']['limite']['richieste'] ) ) ? (int) $cf['emailable']['profile']['limite']['richieste'] : 30,
        'finestra'  => ( isset( $cf['emailable']['profile']['limite']['finestra'] ) )  ? (int) $cf['emailable']['profile']['limite']['finestra']  : 3600
    );

    if( empty( $email ) || filter_var( $email, FILTER_VALIDATE_EMAIL ) === false ) {

        // niente da verificare: il formato lo controlla gia' il form
        http_response_code( 400 );
        $result['errore'] = 'indirizzo mancante o malformato';

    } elseif( ! rateLimitCheck( 'emailable', $limite['richieste'], $limite['finestra'] ) ) {

        // troppe verifiche dallo stesso IP
        http_response_code( 429 );
        $result['errore'] = 'troppe richieste';
        logger( 'verifica di ' . $email . ' rifiutata per limite di frequenza superato', 'emailable', LOG_WARNING );

    } else {

        // prima la cache
        $cache = mailStatusRead( array( $email ) );

        if( isset( $cache[ $email ] ) ) {

            $v = $cache[ $email ];

            // un verdetto senza stato grezzo ( p.es. importato da un gestionale ) si legge dalla tipologia
            if( ! empty( $v['stato'] ) ) {
                $stato = $v['stato'];
            } elseif( isset( $v['se_recapitabile'] ) && $v['se_recapitabile'] !== NULL && empty( $v['se_recapitabile'] ) ) {
                $stato = 'undeliverable';
            } else {
                $stato = 'unknown';
            }

            $result = array(
                'status'       => 'OK',
                'cache'        => true,
                'state'        => $stato,
                'reason'       => $v['motivo'],
                'score'        => $v['punteggio'],
                'accept_all'   => ( $v['se_accept_all'] === NULL ) ? NULL : (bool) $v['se_accept_all'],
                'did_you_mean' => NULL
            );

        } else {

            // poi Emailable, e il verdetto va in cache
            $r = emailableVerifyOne( $email, $esito );

            if( is_array( $r ) ) {

                mailStatusWrite( $r );

                $result = array(
                    'status'       => 'OK',
                    'cache'        => false,
                    'state'        => ( isset( $r['state'] ) )        ? $r['state']        : NULL,
                    'reason'       => ( isset( $r['reason'] ) )       ? $r['reason']       : NULL,
                    'score'        => ( isset( $r['score'] ) )        ? $r['score']        : NULL,
                    'accept_all'   => ( isset( $r['accept_all'] ) )   ? $r['accept_all']   : NULL,
                    'did_you_mean' => ( isset( $r['did_you_mean'] ) ) ? $r['did_you_mean'] : NULL
                );

            } else {

                // disservizio: niente verdetto, e il browser lascia passare
                http_response_code( 502 );
                $result['errore'] = $esito;

            }

        }

    }

    // output
    buildJson( $result );
