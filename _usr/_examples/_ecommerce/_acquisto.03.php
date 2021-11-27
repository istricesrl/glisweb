<?php

    /**
     * test delle cache
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
	$cf['ecommerce']['profile']	    = array_replace_recursive(
        $cf['ecommerce']['profile'],
        array(
            'provider' => array(
                'contanti' => array(
                    'action_url'        => '',                                            // URL della pagina per l'action del form di riepilogo
                ),
                'nexi' => array(
                    'success_url'       => '',                                         // pagina di ritorno in caso di pagamento effettuato con successo
                    'error_url'         => '',                                       // pagina di ritorno in caso di pagamento fallito
                ),
                'paypal' => array(
                    'return_url'        => '',                                            // pagina di ritorno in caso di pagamento completato con successo o fallito
                    'cancel_return_url' => '',                                                  // pagina di ritorno in caso di interruzione della procedura di pagamento
                )
            )
        )
    );

    // inclusione della macro di riepilogo
	require '../../../_mod/_4170.ecommerce/_src/_inc/_macro/_default.riepilogo.php';

    // testo della pagina
    $t = null;
    $i = 0;

    // form di esempio per l'acquisto di un prodotto
    if( isset( $ct['etc']['meta']['action'] ) ) {
        $t .= '<form action="' . $ct['etc']['meta']['action'] . '" method="' . $ct['etc']['meta']['method'] . '">';
        $t .= '<button type="button" onclick="window.open(\'_acquisto.02.php\',\'_self\');">MODIFICA ORDINE</button>';
        $t .= '<button type="submit">PAGA</button>';
        $t .= '</form>';
    } else {
        $t .= '<button type="button" onclick="window.open(\'_acquisto.02.php\',\'_self\');">MODIFICA LA MODALITÀ DI PAGAMENTO</button>';
    }

    // contenuto del carrello
    if( isset( $_SESSION['carrello'] ) ) {
        $t .= '<pre>' . print_r( $_SESSION['carrello'], true ) . '</pre>';
    }

    // profili
    $t .= '<pre>' . print_r( $cf['ecommerce']['profile'], true ) . '</pre>';

    // output
    buildHTML( $t );
