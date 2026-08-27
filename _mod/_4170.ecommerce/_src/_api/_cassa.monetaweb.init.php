<?php

    /**
     * avvio del pagamento online Monetaweb/Nexi dalla cassa del back end
     * ==================================================================
     * Riusa monetawebGetPaymentDetails() del front-end per ottenere l'URL della pagina hosted del
     * provider; la cassa ci reindirizza l'operatore, che inserisce la carta del cliente. A pagamento
     * avvenuto Monetaweb richiama il listener ( _monetaweb.listener.php ), che marca il carrello e
     * lancia checkout.finally.success ( gia' instradato sul sito del carrello ). Ricalca la struttura
     * di _paypal.advanced.order.php.
     *
     * URL:   api/4170.ecommerce/cassa.monetaweb.init   ( POST )
     * Input: return_url = path della cassa a cui tornare in caso di annullamento ( opzionale )
     *
     * @file
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // valore di ritorno
    $result = array();

    // solo operatori autenticati e privilegiati
    if( empty( $_SESSION['account']['id'] ) || ! array_intersect( array( 'roots', 'staff' ), (array)( $_SESSION['account']['gruppi'] ?? array() ) ) ) {

        $result['errore'] = 'operazione non autorizzata';
        buildJson( $result );

    // carrello in sessione
    } elseif( empty( $_SESSION['carrello']['id'] ) ) {

        $result['errore'] = 'nessun carrello in sessione';
        buildJson( $result );

    // provider disponibile e configurato
    } elseif( empty( $cf['ecommerce']['profile']['provider']['monetaweb']['available'] ) || empty( $cf['ecommerce']['profile']['provider']['monetaweb']['init_api'] ) || empty( $cf['ecommerce']['profile']['provider']['monetaweb']['term_id'] ) ) {

        $result['errore'] = 'provider monetaweb non disponibile';
        buildJson( $result );

    } else {

        $idCarrello = $_SESSION['carrello']['id'];

        // registro la scelta del provider sul carrello ( serve alle controller di post checkout )
        mysqlInsertRow( $cf['mysql']['connection'], array( 'id' => $idCarrello, 'provider_pagamento' => 'monetaweb' ), 'carrelli' );
        $_SESSION['carrello']['provider_pagamento'] = 'monetaweb';

        // dati del carrello ( per l'importo )
        $c = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM carrelli WHERE id = ?', array( array( 's' => $idCarrello ) ) );

        // configurazione del provider con gli URL di ritorno e listener nel contesto della cassa:
        // - listener_url: il listener gira sul sito corrente ( il pannello ) e lancia finally.success,
        //   che instrada da solo sul sito del carrello, quindi va bene qualunque sito serva la richiesta;
        // - error_url: la pagina della cassa a cui tornare in caso di annullamento ( dal client, sanitizzato ).
        $k = $cf['ecommerce']['profile']['provider']['monetaweb'];
        $returnUrl = ( isset( $_REQUEST['return_url'] ) && preg_match( '#^/[A-Za-z0-9._/\-]*$#', $_REQUEST['return_url'] ) ) ? $_REQUEST['return_url'] : '/';
        $k['error_url']    = rtrim( $cf['site']['url'], '/' ) . $returnUrl;
        $k['listener_url'] = $cf['site']['url'] . $k['listener'];

        // richiedo a Monetaweb i dettagli di pagamento ( PaymentID + URL della pagina hosted )
        $dettagli = monetawebGetPaymentDetails( $c, $k );

        if( ! empty( $dettagli['redirecturl'] ) ) {
            $result['redirecturl'] = $dettagli['redirecturl'];
        } else {
            $result['errore'] = 'monetaweb non ha restituito un URL di pagamento';
            logWrite( 'monetaweb init cassa: nessun redirecturl per il carrello ' . $idCarrello, 'cassa', LOG_ERR );
        }

        buildJson( $result );

    }
