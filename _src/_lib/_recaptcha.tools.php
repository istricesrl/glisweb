<?php

    /**
     * libreria per la gestione di Google reCaptcha
     * 
     * Questa libreria contiene le funzioni che verificano presso Google i token reCAPTCHA v3 inviati dai form, per
     * distinguere le richieste degli utenti veri da quelle dei bot.
     * 
     * introduzione
     * ============
     * Con reCAPTCHA v3 il javascript di Google, caricato nella pagina con la chiave pubblica del sito, genera un token
     * che il form invia al backend insieme agli altri dati, nel campo __recaptcha_token__ del blocco dati (si veda ad
     * esempio la macro in _src/_twig/_lib/_default.twig). Il backend passa il token e la chiave privata del sito
     * ($cf['google']['profile']['recaptcha']['keys']['private']) a reCaptchaVerifyV3(), che interroga il servizio di
     * verifica di Google e ottiene un punteggio da 0 (bot) a 1 (persona).
     * 
     * Le funzioni di questa libreria sono usate dalla controller dei moduli di contatto
     * (_mod/_CT000.contatti/_src/_config/_750.controller.php, tramite reCaptchaVerifyFormV3()), dal login
     * (_src/_config/_210.auth.php) e dalla verifica antispam del carrello (verificaSpam() in
     * _mod/_4170.ecommerce/_src/_lib/_mysql.utils.add.php); ognuno di questi chiamanti applica la propria soglia e la
     * propria politica per i casi in cui il punteggio non è disponibile.
     * 
     * riferimenti
     * -----------
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
     * TODO spiegare bene i vari componenti che servono per fare funzionare reCaptcha (javascript, html, profilo, eccetera)
     * TODO scrivere un file di esempio che faccia vedere bene come funziona reCaptcha
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni di verifica
     * --------------------
     * Le funzioni in questo gruppo servono per verificare i token reCAPTCHA.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * reCaptchaVerifyV3()              | funzione per il calcolo dello score di Google reCaptcha
     * reCaptchaVerifyFormV3()          | verifica il token reCAPTCHA di un blocco dati e ne registra l'esito
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * restCall()                       | _src/_lib/_rest.tools.php
     * logger()                         | core
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

    /**
     * FUNZIONI DI VERIFICA
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
     * @param       string      $t          il token reCAPTCHA generato nella pagina
     * @param       string      $k          la chiave reCaptcha segreta del sito
     * @param       string      $esito      [out] il motivo del valore restituito, scritto per riferimento
     *
     * @return      float                   il valore dello score (0 in caso di errore o token rifiutato, 1 se il token
     *                                      è valido ma senza punteggio)
     *
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
     * verifica il token reCAPTCHA di un blocco dati e ne registra l'esito
     * 
     * Questa funzione riceve per riferimento il blocco dati di un form (ad esempio un modulo di contatto) e vi aggiunge la
     * chiave __spam__ con lo score, il motivo nella sotto chiave status e l'esito della verifica nella sotto chiave check.
     * I casi sono tre:
     *
     * - se il token è presente e la chiave è configurata, chiama reCaptchaVerifyV3(), scrive lo score, scrive in status
     *   l'esito restituito da reCaptchaVerifyV3() e toglie il token dal blocco dati; se l'esito è 'score' o 'token
     *   rifiutato' check è true solo se lo score è maggiore di 0.1, negli altri casi ( 'token scaduto', 'senza
     *   punteggio', 'nessuna risposta' ) la verifica non è stata possibile e check è true, per cui il blocco passa e lo
     *   status resta a dire perché;
     * - se la chiave è configurata ma il token non è arrivato, scrive score 0, status 'token non ricevuto' e check false;
     * - se la chiave non è configurata (vuota o false), scrive score 1, status 'reCAPTCHA non configurato' e check true,
     *   cioè il form passa senza verifica.
     *
     * Il chiamante ( _mod/_CT000.contatti/_src/_config/_750.controller.php ) registra il contatto se check è true e lo
     * scarta come SPAM altrimenti; il blocco __spam__ finisce nello yaml del contatto salvato.
     *
     * @param       array       $v      il blocco dati del form, modificato per riferimento
     * @param       string      $k      la chiave reCaptcha segreta del sito (default false, cioè non configurata)
     * 
     * @return      void
     * 
     */
    function reCaptchaVerifyFormV3( &$v, $k = false ) {

        // verifico la challenge reCAPTCHA
        if( isset( $v['__recaptcha_token__'] ) && isset( $k ) && ! empty( $k ) ) {

            // registro il valore di bot e l'esito della verifica
            $esito = NULL;
            $bot = reCaptchaVerifyV3( $v['__recaptcha_token__'], $k, $esito );

            // integrazione dei dati
            $v['__spam__']['score'] = $bot;
            $v['__spam__']['status'] = $esito;

            // pulisco il modulo
            unset( $v['__recaptcha_token__'] );

            // punteggio di spam
            // NB: il punteggio decide solo se Google l'ha dato o ha rifiutato il token; un token scaduto, una chiave senza
            // punteggio o un servizio non raggiungibile non sono prove di bot, e il blocco passa marcato dall'esito in
            // status, come fa verificaSpam() in _mod/_4170.ecommerce/_src/_lib/_mysql.utils.add.php ( 2026-09-24 )
            if( $esito == 'score' || $esito == 'token rifiutato' ) {
                $v['__spam__']['check'] = ( $bot > 0.1 ) ? true : false;
            } else {
                $v['__spam__']['check'] = true;
            }

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
