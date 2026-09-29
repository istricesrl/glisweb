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
