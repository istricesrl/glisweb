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

                // NOTA senza template non ci sono né mittente né corpo da accodare
                return NULL;

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
     * accoda un SMS
     *
     * Questa funzione inserisce un SMS nella coda di uscita, la tabella sms_out, da cui lo preleva il task
     * _src/_api/_task/_sms.queue.send.php per inviarlo con la funzione del provider quando è arrivato il momento. Mittente e
     * destinatari vengono salvati serializzati; il server viene salvato così com'è e il task lo cerca in
     * $cf['sms']['servers'], usando $cf['sms']['server'] se è vuoto. Fino al 2026-09-29 il server veniva ignorato e l'SMS
     * partiva sempre dal server di default.
     *
     * @param       object      $c                  la connessione al database
     * @param       int         $timestamp_invio    il timestamp a partire dal quale l'SMS può essere inviato
     * @param       array       $from               il mittente, nel formato 'nome' => 'numero'
     * @param       array       $to                 i destinatari, come array di numeri
     * @param       string      $corpo              il testo dell'SMS
     * @param       string      $server             la chiave del server SMS in $cf['sms']['servers'] ( default NULL, il server di default )
     *
     * @return      int                             l'ID dell'SMS in sms_out, false in caso di errore del database
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
                server
                ,
                mittente
                ,
                destinatari
                ,
                corpo
            ) VALUES (
                ?, ?, ?, ?, ?, ?
            )",
            array(
                array( 's' => time() )
                ,
                array( 's' => $timestamp_invio )
                ,
                array( 's' => $server )
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

    /**
     * normalizza un numero di telefono per l'invio di un SMS
     *
     * Questa funzione riceve un numero di telefono scritto come capita ( spazi, punti, barre, trattini, parentesi ) e lo
     * restituisce in formato internazionale, cioè un + seguito dalle sole cifre, come lo vogliono i provider; le funzioni
     * di invio dei provider ( skebbySend(), ehiwebSend() ) la chiamano su ogni destinatario. La regola è questa, nell'ordine:
     *
     * - un numero che comincia con + o con 00 è già internazionale: si tolgono gli 00 e si mette il +;
     * - un numero che, tolto tutto quello che non è una cifra, è 39 seguito da 10 cifre è già internazionale, con il
     *   prefisso italiano scritto senza + né 00;
     * - tutti gli altri sono numeri italiani, e ci si mette davanti +39.
     *
     * Fino al 2026-09-30 skebbySend() toglieva il + e rimetteva +39 davanti a tutto quello che non cominciava già con +39,
     * quindi +39 333 1234567 diventava +39393331234567, e ehiwebSend() non aggiungeva 39 ai numeri italiani che cominciano
     * per 39 ( i cellulari 39x ).
     *
     * @param       string      $n                  il numero di telefono
     *
     * @return      string|false                    il numero nel formato +<cifre>, false se il numero non contiene cifre
     *
     */
    function string2smsNumber( $n ) {

        // numero scritto con il + davanti ( eventualmente dopo spazi o parentesi )
        $internazionale = ( preg_match( '/^[^0-9]*\+/', (string) $n ) === 1 );

        // tengo solo le cifre
        $cifre = preg_replace( '/[^0-9]/', '', (string) $n );

        // numero senza cifre
        if( $cifre === '' ) {
            return false;
        }

        // numero scritto con 00 davanti
        if( substr( $cifre, 0, 2 ) == '00' ) {
            $internazionale = true;
            $cifre = substr( $cifre, 2 );
        }

        // numero internazionale, o italiano con il 39 già davanti
        if( $internazionale || preg_match( '/^39[0-9]{10}$/', $cifre ) ) {
            return '+' . $cifre;
        }

        // numero italiano
        return '+39' . $cifre;

    }

    function array2smsString($a)
    {

        $ar = array();

        if (is_array($a)) {
            foreach ($a as $k => $m) {

                $ar[] = $k . ' <' . $m . '>';
            }
        } else {
            $ar[] = $a;
        }

        return implode(', ', $ar);

    }
