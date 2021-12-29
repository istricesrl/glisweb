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
                    'action_url'        => 'https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_esito.ok.php',    // URL della pagina per l'action del form di riepilogo
                ),
                'nexi' => array(
                    'success_url'       => 'https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_esito.ok.php',                     // pagina di ritorno in caso di pagamento effettuato con successo
                    'error_url'         => 'https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_esito.ko.php',                           // pagina di ritorno in caso di pagamento fallito
                ),
                'paypal' => array(
                    'return_url'        => 'https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_esito.ok.php',              // pagina di ritorno in caso di pagamento completato con successo o fallito
                    'cancel_url'        => 'https://glisweb.istricesrl.it/_usr/_examples/_ecommerce/_acquisto.03.php',                 // pagina di ritorno in caso di interruzione della procedura di pagamento
                )
            )
        )
    );

    // inclusione della macro di riepilogo
	require '../../../_mod/_4170.ecommerce/_src/_inc/_macro/_carrello.riepilogo.php';

    // testo della pagina
    $t = null;
    $i = 0;

    // form di esempio per l'acquisto di un prodotto
    if( isset( $ct['etc']['meta']['action'] ) ) {
        $t .= '<form action="' . $ct['etc']['meta']['action'] . '" method="' . $ct['etc']['meta']['method'] . '">';
        foreach( $ct['etc']['fields'] as $field => $value ) {
            $t .= '<input type="hidden" name="' . $field . '" value="' . $value . '" />';
        }
        $t .= '<button type="button" onclick="window.open(\'_acquisto.02.php\',\'_self\');">MODIFICA ORDINE</button>';
        $t .= '<button type="submit">PAGA</button>';
        $t .= '</form>';
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
