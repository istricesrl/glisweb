<?php

    /**
     * controller post query per la tabella sms_sent
     *
     * Mittente e destinatari stanno in sms_sent serializzati ( queueSms() ); in lettura diventano testo nella forma
     * "nome <numero>, numero" con array2smsString(), cosi' la scheda li mostra leggibili e li puo' modificare. Ricalca
     * _mail.sent.after.php del modulo MA000.mail.
     *
     * @file
     *
     */

    // log
    logWrite( "controller after per $t/$a", 'controller' );

    // elaborazioni di default dei dati
    switch( strtoupper( $a ) ) {

        case METHOD_GET:

            // se sono presenti dati
            if( isset( $d ) && is_array( $d ) ) {

                // se i dati riguardano un singolo oggetto
                if( in_array( 'id', $ks ) ) {

                    foreach( array( 'mittente', 'destinatari' ) as $vKey ) {
                        if( isset( $d[ $vKey ] ) ) {
                            $d[ $vKey ] = array2smsString( safe_unserialize( $d[ $vKey ] ) );
                        }
                    }

                } else {

                    // elaboro l'intera collezione di oggetti
                    foreach( $d as &$row ) {
                        if( is_array( $row ) ) {
                            foreach( array( 'mittente', 'destinatari' ) as $vKey ) {
                                if( isset( $row[ $vKey ] ) ) {
                                    $row[ $vKey ] = array2smsString( safe_unserialize( $row[ $vKey ] ) );
                                }
                            }
                        }
                    }

                }

            }

        break;

    }
