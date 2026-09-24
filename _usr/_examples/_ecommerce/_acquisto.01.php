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

    // testo della pagina
    $t = null;

    // articoli pubblicati
    $a = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT articoli.id FROM articoli '.
        'INNER JOIN pubblicazioni ON pubblicazioni.id_articolo = articoli.id '.
        'INNER JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia '.
        'WHERE ( pubblicazioni.timestamp_inizio <= unix_timestamp() OR pubblicazioni.timestamp_inizio IS NULL ) '.
        'AND ( pubblicazioni.timestamp_fine > unix_timestamp() OR pubblicazioni.timestamp_fine IS NULL ) '.
        'AND tipologie_pubblicazioni.se_pubblicato = 1'
    );

    // form di esempio per l'acquisto di un prodotto
    foreach( $a as $art ) {
        $t .= '<form action="_acquisto.02.php" method="POST">';
        $t .= '<input type="hidden" name="__carrello__[__articolo__][quantita]" value="1" />';
        $t .= '<input type="hidden" name="__carrello__[__articolo__][id_articolo]" value="' . $art['id'] . '" />';
        $t .= '<button type="submit">ACQUISTA 1x ' . $art['id'] . '</button>';
        $t .= '</form>';
    }
    $t .= '<button type="button" onclick="window.open(\'_acquisto.02.php\',\'_self\');">VAI AL CARRELLO</button>';

    // contenuto del carrello
    if( isset( $_SESSION['carrello'] ) ) {
        $t .= '<pre>' . print_r( $_SESSION['carrello'], true ) . '</pre>';
    }

    // output
    buildHTML( $t );
