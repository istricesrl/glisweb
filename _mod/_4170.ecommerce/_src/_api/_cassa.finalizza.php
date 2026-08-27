<?php

    /**
     * finalizzazione offline di un carrello dalla cassa del back end
     * ==============================================================
     * Registra un pagamento incassato manualmente ( contanti o bonifico ) e lancia le controller
     * di post checkout, cosi' l'ordine di cassa percorre la stessa identica integrazione con il
     * gestionale e le stesse mail di conferma di un acquisto online. Ricalca deliberatamente
     * _paypal.advanced.capture.php: al posto della cattura del provider mette i dati di un
     * pagamento offline dichiarato dall'operatore, poi include le stesse controller post checkout.
     *
     * URL:    api/4170.ecommerce/cassa.finalizza   ( POST )
     * Input:  metodo = contanti | bonifico   ( default contanti )
     *
     * Il pagamento offline usa provider_pagamento = 'contanti', che le controller mappano sulla
     * modalita' gestionale 6 ( pagamento offline / bonifico ); il metodo dichiarato dall'operatore
     * resta nel campo status_pagamento e nel log ai fini di tracciabilita'.
     *
     * @file
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // valore di ritorno
    $result = array();

    // solo operatori autenticati e privilegiati: la finalizzazione incassa e trasmette al gestionale
    if( empty( $_SESSION['account']['id'] ) || ! array_intersect( array( 'roots', 'staff' ), (array)( $_SESSION['account']['gruppi'] ?? array() ) ) ) {

        $result['errore'] = 'operazione non autorizzata';
        buildJson( $result );

    // il carrello da finalizzare e' quello in sessione della cassa
    } elseif( empty( $_SESSION['carrello']['id'] ) ) {

        $result['errore'] = 'nessun carrello in sessione';
        buildJson( $result );

    } else {

        // normalizzazione ID carrello
        $idCarrello = $_SESSION['carrello']['id'];

        // metodo dichiarato dall'operatore ( solo tracciabilita': entrambi sono pagamenti offline )
        $metodo = ( isset( $_REQUEST['metodo'] ) && in_array( $_REQUEST['metodo'], array( 'contanti', 'bonifico' ), true ) ) ? $_REQUEST['metodo'] : 'contanti';

        // guardia di idempotenza: un carrello gia' pagato non va rifinalizzato, altrimenti
        // scriverebbe una seconda volta sul gestionale e manderebbe una seconda mail
        $giaPagato = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT timestamp_pagamento FROM carrelli WHERE id = ?', array( array( 's' => $idCarrello ) ) );

        if( ! empty( $giaPagato ) ) {

            $result['errore']      = 'carrello gia finalizzato';
            $result['id_carrello'] = $idCarrello;
            buildJson( $result );

        } else {

            // file di tracciamento della finalizzazione
            $fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'cassa/' . sprintf( '%08d', $idCarrello ) . '.log';
            checkPath( dirname( $fileRicevuta ) );
            appendToFile( '=== finalizzazione offline ( ' . $metodo . ' ) carrello ' . $idCarrello . ' operatore ' . $_SESSION['account']['id'] . ' === ' . date( 'Y-m-d H:i:s' ) . PHP_EOL, $fileRicevuta );

            // dati del pagamento offline ( mirror di _paypal.advanced.capture.php con valori dichiarati )
            $payment = array(
                'id'                    => $idCarrello,
                'session'               => NULL,
                'provider_checkout'     => basename( __FILE__ ),
                'provider_pagamento'    => 'contanti',
                'timestamp_checkout'    => time(),
                'timestamp_pagamento'   => time(),
                'codice_pagamento'      => NULL,
                'importo_pagamento'     => $_SESSION['carrello']['prezzo_lordo_finale'] ?? NULL,
                'status_pagamento'      => 'incassato in cassa ( ' . $metodo . ' )'
            );

            // registro il pagamento sul carrello
            mysqlInsertRow( $cf['mysql']['connection'], $payment, 'carrelli' );

            // allineo la sessione
            $_SESSION['carrello'] = array_replace_recursive( $_SESSION['carrello'], $payment );

            // controller di post checkout ( gestionale + mail ), gia' instradate sul sito del carrello
            $cnts = glob( glob2custom( DIR_MOD_ATTIVI . '_src/_inc/_controllers/_checkout.finally.success.php' ), GLOB_BRACE );
            sort( $cnts );
            appendToFile( 'controller post checkout trovate: ' . print_r( $cnts, true ), $fileRicevuta );
            foreach( $cnts as $cnt ) {
                require $cnt;
            }

            // log
            logWrite( 'carrello ' . $idCarrello . ' finalizzato in cassa ( ' . $metodo . ' ) dall operatore ' . $_SESSION['account']['id'], 'cassa', LOG_INFO );

            $result['esito']       = 'ok';
            $result['id_carrello'] = $idCarrello;
            $result['metodo']      = $metodo;
            $result['info']        = $info ?? NULL;   // $info e' popolato dalle controller di post checkout

            buildJson( $result );

        }

    }
