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

    // inclusione della macro di riepilogo
	require '../../../_mod/_4170.ecommerce/_src/_inc/_macro/_carrello.esito.php';

    // testo della pagina
    $t = null;

    // esito del pagamento
    if( isset( $ct['etc']['esito'] ) && $ct['etc']['esito'] == 1 ) {
        $t .= '<p>pagamento andato a buon fine</p>';
    } elseif( isset( $ct['etc']['esito'] ) && $ct['etc']['esito'] == 2 ) {
        $t .= '<p>ordine in lavorazione</p>';
    } else {
        $t .= '<p>pagamento non andato a buon fine</p>';
    }

    // form di esempio per l'acquisto di un prodotto
    $t .= '<button type="button" onclick="window.open(\'_acquisto.01.php\',\'_self\');">TORNA AGLI ACQUISTI</button>';

    // contenuto del carrello
    if( isset( $_SESSION['carrello'] ) ) {
        $t .= '<pre>' . print_r( $_SESSION['carrello'], true ) . '</pre>';
    }

    // output
    buildHTML( $t );
