<?php

    /**
     * endpoint di tracciamento delle mail scartate dalla validazione Emailable
     *
     * Chiamato in POST (JSON) da _src/_twig/_inc/_emailable.close.twig ( e dal gemello legacy
     * _src/_html/_inc/_emailable.close.html ) quando _src/_api/_emailable.verifica.php ha appena
     * risposto 'undeliverable' per il campo mail di un form, con il corpo
     *
     *     { "email": "...", "stato": "...", "motivo": "...", "score": ..., "suggerimento": "...", "form": "...", "pagina": "..." }
     *
     * Ogni scarto viene accodato come riga JSON (JSONL) nel file mensile
     * var/spool/emailable/scarti/AAAAMM.jsonl, con IP e user agent della richiesta. Lo snippet lo
     * chiama fire-and-forget e non legge la risposta: qualunque esito qui non tocca il form.
     *
     * protezioni
     * ==========
     * L'endpoint e' pubblico ( i form lo sono ), e senza protezioni chiunque potrebbe riempire lo
     * spool di righe inventate. Per questo:
     *
     * - si registra SOLO un indirizzo che la cache dei verdetti in `mail_status` da' come
     *   'undeliverable': il verdetto lo ha ottenuto il server in _emailable.verifica.php un attimo
     *   prima, e stato, motivo e punteggio si prendono da li' e non dal corpo della richiesta. E' lo
     *   stesso principio della verifica: il browser non puo' dichiarare un verdetto. Sui deploy dove
     *   la tabella non esiste, o se la scrittura in cache e' fallita, lo scarto non si registra: e'
     *   un log, e perderlo non ferma niente;
     * - passa dal limitatore del firewall, rateLimitCheck(), sul canale 'emailable.scarti' e con lo
     *   stesso tetto per IP della verifica ( emailable.profiles.<PROFILO>.limite, default 30
     *   richieste all'ora ): ogni scarto legittimo segue una verifica, quindi non ne puo' superare
     *   il numero;
     * - il file mensile ha una dimensione massima, emailable.profiles.<PROFILO>.scarti.dimensione
     *   in byte ( default 10 MB, qualche decina di migliaia di righe ): superata, gli scarti del mese
     *   non si registrano piu' e ogni rifiuto finisce nel log `emailable`.
     *
     * Risponde OK quando lo scarto e' stato registrato, altrimenti KO con 400 ( corpo malformato o
     * indirizzo non scartato dalla verifica ), 429 ( limite di frequenza superato ) o 507 ( file
     * mensile pieno ).
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

    // indirizzo scartato, normalizzato come la chiave della cache
    $email = ( is_array( $data ) && isset( $data['email'] ) ) ? mailStatusNormalize( substr( (string) $data['email'], 0, 254 ) ) : '';

    // limite di frequenza per IP, lo stesso della verifica
    $limite = array(
        'richieste' => ( isset( $cf['emailable']['profile']['limite']['richieste'] ) ) ? (int) $cf['emailable']['profile']['limite']['richieste'] : 30,
        'finestra'  => ( isset( $cf['emailable']['profile']['limite']['finestra'] ) )  ? (int) $cf['emailable']['profile']['limite']['finestra']  : 3600
    );

    // dimensione massima del file mensile
    $dimensione = ( isset( $cf['emailable']['profile']['scarti']['dimensione'] ) ) ? (int) $cf['emailable']['profile']['scarti']['dimensione'] : 10485760;

    // file di spool del mese
    $dir  = DIR_VAR_SPOOL . 'emailable/scarti/';
    $file = $dir . date( 'Ym' ) . '.jsonl';

    if( empty( $email ) || filter_var( $email, FILTER_VALIDATE_EMAIL ) === false ) {

        // niente da registrare
        http_response_code( 400 );
        $result['errore'] = 'indirizzo mancante o malformato';

    } elseif( ! rateLimitCheck( 'emailable.scarti', $limite['richieste'], $limite['finestra'] ) ) {

        // troppe segnalazioni dallo stesso IP
        http_response_code( 429 );
        $result['errore'] = 'troppe richieste';
        logger( 'scarto di ' . $email . ' rifiutato per limite di frequenza superato', 'emailable', LOG_WARNING );

    } else {

        // il verdetto si legge dalla cache, non dal corpo della richiesta
        $cache = mailStatusRead( array( $email ) );

        if( ! isset( $cache[ $email ] ) || mailStatusState( $cache[ $email ] ) !== 'undeliverable' ) {

            // indirizzo mai verificato, o verificato come recapitabile
            http_response_code( 400 );
            $result['errore'] = 'indirizzo non scartato dalla verifica';

        } elseif( file_exists( $file ) && filesize( $file ) >= $dimensione ) {

            // file del mese pieno
            http_response_code( 507 );
            $result['errore'] = 'spool degli scarti pieno';
            logger( 'scarto di ' . $email . ' non registrato, ' . $file . ' ha raggiunto ' . $dimensione . ' byte', 'emailable', LOG_WARNING );

        } else {

            // sanitizzazione: rimuove caratteri di controllo e taglia a 255 per campo
            $clean = function( $v ) {
                return trim( str_replace( array( "\r", "\n", "\t" ), ' ', substr( (string) $v, 0, 255 ) ) );
            };

            $v = $cache[ $email ];

            $record = array(
                'ts'           => date( 'Y-m-d H:i:s' ),
                'email'        => $email,
                'stato'        => mailStatusState( $v ),
                'motivo'       => (string) $v['motivo'],
                'score'        => (string) $v['punteggio'],
                'suggerimento' => isset( $data['suggerimento'] ) ? $clean( $data['suggerimento'] ) : '',
                'form'         => isset( $data['form'] )         ? $clean( $data['form'] )         : '',
                'pagina'       => isset( $data['pagina'] )       ? $clean( $data['pagina'] )       : '',
                'ip'           => isset( $_SERVER['REMOTE_ADDR'] )     ? $_SERVER['REMOTE_ADDR'] : '',
                'ua'           => isset( $_SERVER['HTTP_USER_AGENT'] ) ? $clean( $_SERVER['HTTP_USER_AGENT'] ) : '',
            );

            // directory di spool dedicata (creata ricorsivamente se assente)
            checkPath( $dir );

            // accodamento atomico di una riga JSON nel file mensile
            file_put_contents(
                $file,
                json_encode( $record ) . PHP_EOL,
                FILE_APPEND | LOCK_EX
            );

            $result['status'] = 'OK';

        }

    }

    // output
    buildJson( $result );
