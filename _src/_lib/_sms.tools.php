<?php

    /**
     * libreria per l'invio di SMS
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // NOTA la funzione smsSend() non esiste perché va chiamata la funzione specifica per il provider usato (Skebby, Ehiweb, eccetera)

    /**
     *
     *
     * @todo finire di implementare
     * @todo finire di documentare
     *
     */
    function queueSmsFromTemplate( $c, $t, $d, $timestamp_invio, $to, $l = 'it-IT', $server = NULL ) {

        // debug
        // print_r( $t );

        // valuto il template manager
        switch( $t['type'] ) {

            case 'twig':

                // avvio di Twig
                $twig = new \Twig\Environment( new Twig\Loader\ArrayLoader( $t[ $l ] ) );
                $from = new \Twig\Environment( new Twig\Loader\ArrayLoader( array( 'nome' => array_key_first( $t[ $l ]['from'] ), 'numero' => reset( $t[ $l ]['from'] ) ) ) );

                // variabili da passare a queueSms()
                $mittente	= array( $from->render( 'nome', $d ) => $from->render( 'numero', $d ) );
                $corpo		= $twig->render( 'testo', $d );

                // spacchetto i destinatari
                if( is_array( $to ) ) {
                    $destinatari = $to;
                } else {
                    $destinatari = explode( ';', $to );
                }

                // se è definito nel template imposto il destinatario
                if( array_key_exists('to', $t[ $l ] ) && ! empty( $t[ $l ]['to'] ) ) {
                    $destinatari[] = $t[ $l ]['to'];
                }

            break;

            default:

                // debug
                logWrite( 'tipo di template non supportato: ' . $t['type'], 'sms', LOG_ERR );

		    break;

	    }

        // accodo l'SMS
        $id = queueSms(
            $c,
            $timestamp_invio,
            $mittente,
            $destinatari,
            $corpo,
            $server
        );


        // ritorno
            return $id;

    }

    /**
     *
     *
     *
     * @todo finire di documentare
     *
     */
    function queueSms( $c, $timestamp_invio, $from, $to, $corpo, $server = NULL ) {

        $id = mysqlQuery(
            $c,
            "INSERT INTO sms_out (
                timestamp_composizione
                ,
                timestamp_invio
                ,
                mittente
                ,
                destinatari
                ,
                corpo
            ) VALUES (
                ?, ?, ?, ?, ?
            )",
            array(
                array( 's' => time() )
                ,
                array( 's' => $timestamp_invio )
                ,
                array( 's' => serialize( $from ) )
                ,
                array( 's' => serialize( $to ) )
                ,
                array( 's' => $corpo )
            )
        );

	    return $id;

    }

    // NOTA la funzione processSmsQueue() non esiste in quanto l'elaborazione della coda viene fatta direttamente nel task
