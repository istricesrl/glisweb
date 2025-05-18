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
     * @param    string    t       token
     * @param    string    k       chiave reCaptcha segreta del sito
     * 
     * @return                  il valore dell score
     */

     function reCaptchaVerifyV3( $t, $k ) {

        $dati = array(
            'secret' => $k,
            'response' => $t
        );
        
        $r = restCall( 'https://www.google.com/recaptcha/api/siteverify', METHOD_GET, $dati, 'query', MIME_APPLICATION_JSON, $status );

        if( isset( $r['score'] ) ){
            logger(  $r['score']  . PHP_EOL, 'recaptcha' );
            $result = $r['score'];
        }
        else{
            logger(  'nessuno score restituito'  . PHP_EOL, 'recaptcha' );
            $result = 0;
        }
        
        return $result;

    }
