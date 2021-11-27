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

    // testo della pagina
    $t = null;

    // form di esempio per l'acquisto di un prodotto
    $t .= '<form action="_acquisto.02.php" method="POST">';
    $t .= '<input type="hidden" name="__carrello__[__articolo__][quantita]" value="1" />';
    $t .= '<input type="hidden" name="__carrello__[__articolo__][id_articolo]" value="TEST.001" />';
    $t .= '<button type="submit">ACQUISTA 1x TEST.001</button>';
    $t .= '<button type="button" onclick="window.open(\'_acquisto.02.php\',\'_self\');">VAI AL CARRELLO</button>';
    $t .= '</form>';

    // contenuto del carrello
    if( isset( $_SESSION['carrello'] ) ) {
        $t .= '<pre>' . print_r( $_SESSION['carrello'], true ) . '</pre>';
    }

    // output
    buildHTML( $t );
