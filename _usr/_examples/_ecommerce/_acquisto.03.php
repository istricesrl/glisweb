<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../../../_src/_config.php';

    // configurazione di esempio
	$cf['ecommerce']['profile']	        = array_replace_recursive(
        $cf['ecommerce']['profile'],
        array(
            'provider' => array(
                'contanti' => array(
                    'action_url'        => 'https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_esito.ck.php',     // URL della pagina per l'action del form di riepilogo (macro _carrello.checkout.php)
                ),
                'nexi' => array(
                    'success_url'       => 'https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_esito.php',        // pagina di ritorno in caso di pagamento completato con successo o fallito (macro _carrello.esito.php)
                    'error_url'         => 'https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_esito.php',        // pagina di ritorno in caso di pagamento completato con successo o fallito (macro _carrello.esito.php)
                ),
                'paypal' => array(
                    'return_url'        => 'https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_esito.php',        // pagina di ritorno in caso di pagamento completato con successo o fallito (macro _carrello.esito.php)
                    'cancel_url'        => 'https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_acquisto.03.php',  // pagina di ritorno in caso di interruzione della procedura di pagamento
                ),
                'paypal-advanced' => array(
                    'return_url'        => 'https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_esito.php',        // pagina di ritorno in caso di pagamento completato con successo o fallito (macro _carrello.esito.php)
                    'cancel_url'        => 'https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_acquisto.03.php',  // pagina di ritorno in caso di interruzione della procedura di pagamento
                )
            )
        )
    );

    // inclusione della macro di riepilogo
	require '../../../_mod/_4170.ecommerce/_src/_inc/_macro/_carrello.riepilogo.php';

    // testo della pagina
    $t = null;
    $i = 0;

    // debug
    // print_r( $cf['ecommerce']['profile'] );

    // codice aggiuntivo per PayPal Advanced
    if( isset( $ct['etc']['client_token'] ) ) {
        // https://developer.paypal.com/sdk/js/configuration/#disable-funding
        if( isset( $cf['ecommerce']['profile']['provider']['paypal-advanced']['return_url'] ) ) {
            $t .= '<script> var return_url = "'.$cf['ecommerce']['profile']['provider']['paypal-advanced']['return_url'].'";</script>';
        }
        $t .= '<script src="https://www.paypal.com/sdk/js?components=buttons,hosted-fields&amp;currency=EUR&amp;disable-funding=sofort,mybank&amp;client-id='.$ct['ecommerce']['profile']['provider']['paypal-advanced']['client_id'].'" data-client-token="'.$ct['etc']['client_token'].'"></script>';

    }

    // form di esempio per l'acquisto di un prodotto
    if( isset( $ct['etc']['meta']['action'] ) && ! empty( $ct['etc']['meta']['action'] ) && isset( $ct['etc']['meta']['method'] ) && ! empty( $ct['etc']['meta']['method'] ) ) {
        $t .= '<form action="' . $ct['etc']['meta']['action'] . '" method="' . $ct['etc']['meta']['method'] . '">';
        foreach( $ct['etc']['fields'] as $field => $value ) {
            $t .= '<input type="hidden" name="' . $field . '" value="' . $value . '" />';
        }
        $t .= '<button type="button" onclick="window.open(\'_acquisto.02.php\',\'_self\');">MODIFICA ORDINE</button>';
        $t .= '<button type="submit">PAGA</button>';
        $t .= '</form>';
    } elseif( isset( $ct['etc']['client_token'] ) ) {
        $t .= '<div id="paypal-button-container" class="paypal-button-container"></div>';
        if( true ) {    // TODO mettere un'opzione nel profilo PayPal advanced
            $t .= '<div class="card_container">';
            $t .= '<form id="card-form">';
            $t .= '  <label for="card-number">Card Number</label><div id="card-number" class="card_field"></div>';
            $t .= '  <div>';
            $t .= '    <label for="expiration-date">Expiration Date</label>';
            $t .= '    <div id="expiration-date" class="card_field"></div>';
            $t .= '  </div>';
            $t .= '  <div>';
            $t .= '    <label for="cvv">CVV</label><div id="cvv" class="card_field"></div>';
            $t .= '  </div>';
            $t .= '  <label for="card-holder-name">Name on Card</label>';
            $t .= '  <input type="text" id="card-holder-name" name="card-holder-name" autocomplete="off" placeholder="card holder name"/>';
            $t .= '  <div>';
            $t .= '    <label for="card-billing-address-street">Billing Address</label>';
            $t .= '    <input type="text" id="card-billing-address-street" name="card-billing-address-street" autocomplete="off" placeholder="street address"/>';
            $t .= '  </div>';
            $t .= '  <div>';
            $t .= '    <label for="card-billing-address-unit">&nbsp;</label>';
            $t .= '    <input type="text" id="card-billing-address-unit" name="card-billing-address-unit" autocomplete="off" placeholder="unit"/>';
            $t .= '  </div>';
            $t .= '  <div>';
            $t .= '    <input type="text" id="card-billing-address-city" name="card-billing-address-city" autocomplete="off" placeholder="city"/>';
            $t .= '  </div>';
            $t .= '  <div>';
            $t .= '    <input type="text" id="card-billing-address-state" name="card-billing-address-state" autocomplete="off" placeholder="state"/>';
            $t .= '  </div>';
            $t .= '  <div>';
            $t .= '    <input type="text" id="card-billing-address-zip" name="card-billing-address-zip" autocomplete="off" placeholder="zip / postal code"/>';
            $t .= '  </div>';
            $t .= '  <div>';
            $t .= '    <input type="text" id="card-billing-address-country" name="card-billing-address-country" autocomplete="off" placeholder="country code" />';
            $t .= '  </div>';
            $t .= '  <br/><br/>';
            $t .= '  <button value="submit" id="submit" class="btn">Pay</button>';
            $t .= '</form>';
            $t .= '</div>';
        }
        $t .= '<script src="/_src/_js/_lib/_paypal.js"></script>';
    } else {
        $t .= '<button type="button" onclick="window.open(\'_acquisto.02.php\',\'_self\');">MODIFICA IL CARRELLO</button>';
    }

    // status corrente del sito
    $t .= '<pre>' . $cf['site']['status'] . '</pre>';

    // parametri per la costruzione del form
    if( isset( $ct['etc'] ) ) {
        $t .= '<pre>' . print_r( $ct['etc'], true ) . '</pre>';
    }

    // contenuto del carrello
    if( isset( $_SESSION['carrello'] ) ) {
        $t .= '<pre>' . print_r( $_SESSION['carrello'], true ) . '</pre>';
    }

    // profili
    // $t .= '<pre>' . print_r( $cf['ecommerce']['profile'], true ) . '</pre>';

    // output
    buildHTML( $t );
