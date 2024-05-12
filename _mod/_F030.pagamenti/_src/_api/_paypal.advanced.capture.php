<?php

    /**
     * API per la cattura del pagamento in PayPal Advanced
     * 
     * 
     * 
     * 
     * introduzione
     * ============
     * 
     * 
     * 
     * 
     * 
     * recupero dati e dettagli dell'ordine
     * ====================================
     * PayPal passa come $_REQUEST['id'] l'ID dell'ordine che è stato creato precedentemente tramite la chiamata all'API di creazione dell'ordine; questo
     * dato quindi serve per mantenere la continuità fra ordine e pagamento e viene salvato nella colonna ordine_pagamento della tabella pagamenti alla
     * fine dell'esecuzione dell'API di creazione dell'ordine (vedi le ultime righe di _mod/_F030.pagamenti/_src/_api/_paypal.advanced.order.php per i dettagli).
     * 
     * Alcuni dettagli dell'ordine, fra cui il return_url, vengono salvati in memcache e il token di memcache viene salvato nella colonna token_pagamento
     * della tabella pagamenti, sempre nell'API di creazione degli ordini.
     * 
     * 
     */

    // inclusione del framework
	require '../../../../_src/_config.php';

    // debug
    // print_r( $_SESSION['carrello'] );
    // print_r( $_REQUEST );

    // inizializzazione status
    $result = array();

    // ID dell'ordine per la cattura del pagamento
    if( isset( $_REQUEST['id'] ) ) {

        // log
        logger( 'dati in ingresso: ' . print_r( $_REQUEST, true ), 'details/paypal-advanced/capture-api' );

        // recupero pagamento
        $pagamento = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM pagamenti WHERE ordine_pagamento = ?',
            array( array( 's' => $_REQUEST['id'] ) )
        );

        // recupero i dettagli da memcache
        $dettagli = memcacheRead( $cf['memcache']['connection'], $pagamento['token_pagamento'] );

        // nome del file di ricevuta
        $fileRicevuta = DIR_VAR_SPOOL_PAYMENT . 'details/paypal-advanced/pagamenti.' . sprintf( '%08d', $pagamento['id'] ) . '.log';

        // chiamata
        $result = restCall(
            $cf['paypal']['profile']['order_api'].'/'.$_REQUEST['id'].'/capture',
            METHOD_POST,
            NULL,
            MIME_APPLICATION_JSON,
            MIME_APPLICATION_JSON,
            $status,
            array(
                'PayPal-Request-Id' => $_REQUEST['id']
            ),
            NULL,
            NULL,
            $error,
            paypalAdvancedGetAccessToken( $cf['paypal']['profile'] )
        );

        // debug
        // print_r( $result );
        // print_r( $status );
        // print_r( $error );

        // TODO verificare che il pagamento sia andato a buon fine qui
        // $result[purchase_units][0][payments][captures][0][status] == COMPLETED

        // log
        logger( 'dati di cattura: ' . print_r( $result, true ), 'details/paypal-advanced/capture-api' );

        // log
        appendToFile( 'esito cattura pagamento: ' . print_r( $result, true ), $fileRicevuta );

        // URL di ritorno
        if( $result['purchase_units'][0]['payments']['captures'][0]['status'] == 'COMPLETED' ) {

            // dati di pagamento
            $payment = array(
                'id'						=> $pagamento['id'],
                'timestamp_pagamento'		=> time(),
                'codice_pagamento'			=> $result['purchase_units'][0]['payments']['captures'][0]['id'],
                'importo_pagamento'			=> $result['purchase_units'][0]['payments']['captures'][0]['amount']['value'],
                'status_pagamento'			=> $result['purchase_units'][0]['payments']['captures'][0]['status']
            );

            // registro il pagamento
            mysqlInsertRow(
                $cf['mysql']['connection'],
                $payment,
                'pagamenti'
            );

            // controller post checkout
            $cnts = glob( glob2custom( DIR_MOD_ATTIVI . '_src/_inc/_controllers/_pagamento.finally.success.php' ), GLOB_BRACE );

            // ordinamento delle controller
            sort( $cnts );

            // log
            appendToFile( 'controller post pagamento trovate: ' . print_r( $cnts, true ), $fileRicevuta );

            // inclusione delle controller post checkout
            foreach( $cnts as $cnt ) {
                require $cnt;
            }

            // log
            logWrite( 'pagamento effettuato con successo: ' . $_REQUEST['id'], 'paypal', LOG_INFO );

            // URL di redirect in caso di successo
            // TODO leggere dal pagamento?
            $result['return'] = $dettagli['success'];

        } else {

            // controller post checkout
            $cnts = glob( glob2custom( DIR_MOD_ATTIVI . '_src/_inc/_controllers/_pagamento.finally.failure.php' ), GLOB_BRACE );

            // ordinamento delle controller
            sort( $cnts );

            // log
            appendToFile( 'controller post checkout trovate: ' . print_r( $cnts, true ), $fileRicevuta );

            // inclusione delle controller post checkout
            foreach( $cnts as $cnt ) {
                require $cnt;
            }

            // TODO in caso di fallimento settare come URL di redirect l'URL della pagina di errore
            $result['return'] = $dettagli['failure'];

        }

    } else {

        // TODO settare come URL di redirect l'URL della pagina di errore
        $result['return'] = $dettagli['failure'];

    }

    // TODO restituire l'URL di redirect
    buildJson( $result );
