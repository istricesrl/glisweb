<?php

    /**
     * sblocco dell'accesso sospeso dal firewall applicativo
     *
     * È la pagina a cui rimanda l'accesso sospeso ( _src/_inc/_macro/_security.php e l'ErrorDocument 429 del
     * .htaccess ), l'unica che l'IP bandito può raggiungere. Il bottone porta il token reCAPTCHA v3 generato da
     * cms.formButton(), che si verifica con reCaptchaVerifyFormV3(); con un punteggio vero di almeno 0.5 il bando
     * viene tolto. Lo sblocco serve a trasformare un falso positivo in un disagio di un minuto invece che di una
     * settimana, e per questo ha dei limiti:
     *
     * - i tentativi passano da rateLimitCheck(), dieci all'ora per IP, perché ognuno è una chiamata a Google;
     * - lo stesso IP si sblocca al massimo una volta ogni SECURITY_UNBAN_INTERVAL secondi, e lo sblocco non azzera la
     *   recidiva: un IP che si fa bandire di nuovo sale di gradino;
     * - senza chiavi reCAPTCHA, o se Google non dà un punteggio, lo sblocco non avviene.
     *
     * Ogni tentativo finisce nel registro degli attacchi dell'IP, e il resoconto notturno
     * ( _src/_api/_task/_security.clean.php ) mette gli sblocchi fra gli allarmi.
     *
     */

    // bando dell'IP corrente
    $ban = DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'];
    $_REQUEST['__sblocco__']['__bandito__'] = ( file_exists( $ban ) && filemtime( $ban ) > time() );

    // tentativo di sblocco
    if( $_REQUEST['__sblocco__']['__bandito__'] && isset( $_REQUEST['__sblocco__']['__recaptcha_token__'] ) ) {

        // verifica umana, con un limite ai tentativi
        if( rateLimitCheck( 'security.sblocco', 10, 3600 ) ) {
            reCaptchaVerifyFormV3( $_REQUEST['__sblocco__'], ( ( isset( $cf['google']['profile']['recaptcha']['keys']['private'] ) ) ? $cf['google']['profile']['recaptcha']['keys']['private'] : false ) );
            $spam = $_REQUEST['__sblocco__']['__spam__'];
        } else {
            $spam = array( 'status' => 'troppi tentativi', 'score' => 0 );
        }

        // sblocco, al massimo uno per intervallo
        if( $spam['status'] == 'score' && $spam['score'] >= 0.5 && rateLimitCheck( 'security.sblocco.riuscito', 1, SECURITY_UNBAN_INTERVAL ) ) {
            securityLog( 'sblocco con verifica umana, punteggio ' . $spam['score'] . ', motivo del bando: ' . trim( (string) @file_get_contents( $ban ) ) );
            @unlink( $ban );
            $_REQUEST['__sblocco__']['__bandito__'] = false;
            $_REQUEST['__sblocco__']['__esito__']['testo'] = array(
                'it-IT' => 'accesso sbloccato, puoi tornare al sito',
                'en-GB' => 'access unlocked, you can go back to the site'
            );
        } else {
            securityLog( 'sblocco negato: ' . $spam['status'] . ' ' . $spam['score'] );
            $_REQUEST['__sblocco__']['__esito__']['testo'] = array(
                'it-IT' => 'non è stato possibile sbloccare l\'accesso; riprova più tardi',
                'en-GB' => 'access could not be unlocked; please try again later'
            );
        }

    } elseif( $_REQUEST['__sblocco__']['__bandito__'] ) {

        // messaggio
        $_REQUEST['__sblocco__']['__esito__']['testo'] = array(
            'it-IT' => 'dal tuo indirizzo sono arrivate richieste che il sito considera un attacco, e l\'accesso è sospeso; se sei una persona puoi sbloccarlo',
            'en-GB' => 'requests from your address look like an attack, so access is suspended; if you are a person you can unlock it'
        );

    } else {

        // messaggio
        $_REQUEST['__sblocco__']['__esito__']['testo'] = array(
            'it-IT' => 'il tuo accesso non è sospeso',
            'en-GB' => 'your access is not suspended'
        );

    }
