<?php

    /**
     * controller pre query per la tabella sms_sent
     *
     * Mittente e destinatari stanno in sms_sent serializzati ( queueSms() ); la scheda li mostra e li riceve come testo
     * nella forma "nome <numero>, numero", e qui il testo torna array serializzato con smsString2array(). Ricalca
     * _mail.sent.before.php del modulo MA000.mail.
     *
     * @file
     *
     */

    // log
    logWrite( "controller before per $t/$a", 'controller' );

    // controllo azione corrente
    switch( strtoupper( $a ) ) {

        case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:

            // mittente e destinatari dal testo della scheda all'array serializzato
            foreach( array( 'mittente', 'destinatari' ) as $vKey ) {
                if( isset( $vs[ $vKey ] ) && ! is_array( @unserialize( (string) $vs[ $vKey ]['s'], array( 'allowed_classes' => false ) ) ) ) {
                    $vs[ $vKey ]['s'] = serialize( smsString2array( $vs[ $vKey ]['s'] ) );
                }
            }

        break;

    }
