<?php

    /**
     * libreria per la gestione di Google reCaptcha
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * vedi:
     * - https://stackoverflow.com/questions/51507695/google-recaptcha-v3-example-demo
     * - https://stackoverflow.com/questions/48224799/test-invisible-recaptcha
     * - https://www.flood.io/blog/how-to-test-recaptcha-when-running-load-tests
     * - https://stackoverflow.com/questions/48600034/recaptchaerror-for-site-owner-invalid-site-key
     * - https://stackoverflow.com/questions/1241947/how-do-i-show-multiple-recaptchas-on-a-single-page
     * - https://developers.google.com/recaptcha/docs/v3
     * 
     * pannello di controllo reCAPTCHA:
     * - https://www.google.com/recaptcha/about/
     * 
     * 
     * 
     * TODO documentare
     * TODO spiegare bene i vari componenti che servono per fare funzionare reCaptcha (javascript, html, profilo, eccetera)
     * TODO scrivere un file di esempio che faccia vedere bene come funziona reCaptcha
     * 
     * 
     */

    /**
     * funzione per il calcolo dello score di Google reCaptcha
     * 
     * La modalità di integrazione di Google reCaptcha utilizzata dal framework fa sì che nell'html della pagina si venga a creare 
     * una textarea di id='g-recaptcha-response' in cui viene scritto automaticamente un valore di token
     * 
     * La funzione fa una restCall a un ws di Google passando il token e la chiave reCaptcha segreta del sito.
     * Il ws ritorna un array contenente la chiave 'score' con un punteggio da 0 a 1 che misura l'umanità dell'utente.
     * Tanto più il punteggio è vicino a 1 quanto più è probabile si tratti di una persona (tipicamente sarà > 0.7).
     * 
     * 
     * Il parametro $esito, passato per riferimento, dice al chiamante *perché* ha ottenuto quel
     * valore: 'score' ( Google ha risposto con un punteggio ), 'token rifiutato' ( token assente,
     * malformato o contraffatto ), 'token scaduto' ( timeout-or-duplicate: token oltre i 2 minuti
     * di validità o già consumato, tipico di un utente vero che ritenta ), 'senza punteggio'
     * ( token valido ma chiave non v3 ), 'nessuna risposta' ( servizio non raggiungibile / quota
     * esaurita / 5xx ). Serve a distinguere un bot da un disservizio o da una semplice
     * riprovata: senza questa informazione lo score 0 restituito in caso di errore di rete è
     * indistinguibile da un bot e blocca utenti legittimi.
     *
     * @param    string    t       token
     * @param    string    k       chiave reCaptcha segreta del sito
     * @param    string    esito   [out] motivo del valore restituito
     *
     * @return                  il valore dell score
     */

     function reCaptchaVerifyV3( $t, $k, &$esito = NULL ) {

        $dati = array(
            'secret' => $k,
            'response' => $t
        );

        $r = restCall( 'https://www.google.com/recaptcha/api/siteverify', METHOD_GET, $dati, 'query', MIME_APPLICATION_JSON, $status );

        if( isset( $r['score'] ) ){

            // caso normale: Google ha risposto con un punteggio
            logger(  $r['score'], 'recaptcha' );
            $esito = 'score';
            $result = $r['score'];

        }
        elseif( isset( $r['success'] ) && $r['success'] === false ){

            // Google ha risposto e ha rifiutato il token
            $codici = ( isset( $r['error-codes'] ) && is_array( $r['error-codes'] ) ) ? $r['error-codes'] : array();
            logger(  'token rifiutato per ' . $k . ': ' . implode( ', ', ( empty( $codici ) ? array( 'nessun dettaglio' ) : $codici ) ), 'recaptcha' );

            if( in_array( 'timeout-or-duplicate', $codici ) ) {

                // token scaduto ( vale 2 minuti ) oppure già consumato: è quello che succede a un
                // utente vero che compila con calma o che ritenta dopo un errore di validazione
                // senza che il widget sia stato azzerato, NON è la firma di un bot
                $esito = 'token scaduto';
                $result = 0;

            } else {

                // token assente, malformato o contraffatto: qui la manomissione c'è
                $esito = 'token rifiutato';
                $result = 0;

            }

        }
        elseif( isset( $r['success'] ) ){

            // Google ha validato il token ma non ha restituito un punteggio: succede con le
            // chiavi reCAPTCHA v2, che non producono score; non c'è nulla da valutare
            logger(  'token valido ma senza punteggio per ' . $k . ' ( chiave non v3? )', 'recaptcha' );
            $esito = 'senza punteggio';
            $result = 1;

        }
        else{

            // nessuna risposta utile dal servizio: rete, quota, 5xx
            logger(  'nessuno score restituito per ' . $k . ' / ' . $t, 'recaptcha' );
            $esito = 'nessuna risposta';
            $result = 0;

        }

        return $result;

    }

    /**
     * 
     * 
     * 
     * TODO documentare
     * 
     */
    function reCaptchaVerifyFormV3( &$v, $k = false ) {

        // verifico la challenge reCAPTCHA
        if( isset( $v['__recaptcha_token__'] ) && isset( $k ) && ! empty( $k ) ) {

            // registro il valore di bot
            $bot = reCaptchaVerifyV3( $v['__recaptcha_token__'], $k );

            // integrazione dei dati
            $v['__spam__']['score'] = $bot;

            // pulisco il modulo
            unset( $v['__recaptcha_token__'] );

            // punteggio di spam
            $v['__spam__']['check'] = ( $bot > 0.1 ) ? true : false;

        } elseif( ! isset( $v['__recaptcha_token__'] ) && isset( $k ) && ! empty( $k ) ) {

            // integrazione dei dati
            $v['__spam__']['score'] = 0;
            $v['__spam__']['status'] = 'token non ricevuto';

            // punteggio di spam
            $v['__spam__']['check'] = false;

        } else {

            // integrazione dei dati
            $v['__spam__']['score'] = 1;
            $v['__spam__']['status'] = 'reCAPTCHA non configurato';

            // punteggio di spam
            $v['__spam__']['check'] = true;

        }

    }
