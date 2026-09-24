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
    $i = 0;

    // form di esempio per l'acquisto di un prodotto
    if( isset( $_SESSION['carrello']['articoli'] ) ) {
        $t .= '<form id="carrello" action="_acquisto.03.php" method="POST">';
        $t .= '<div>NOME<input type="text" name="__carrello__[intestazione_nome]" value="'.$_SESSION['carrello']['intestazione_nome'].'" /></div>';
        $t .= '<div>COGNOME<input type="text" name="__carrello__[intestazione_cognome]" value="'.$_SESSION['carrello']['intestazione_cognome'].'" /></div>';
        $t .= '<div>MAIL<input type="text" name="__carrello__[intestazione_mail]" value="'.$_SESSION['carrello']['intestazione_mail'].'" /></div>';
        foreach( $_SESSION['carrello']['articoli'] as $articolo => $dati ) {
            $t .= '<div>';
            $t .= '<input type="hidden" name="__carrello__[__articoli__]['.$articolo.'][id_articolo]" value="'.$dati['id_articolo'].'" />';
            $t .= $dati['id_articolo'];
            $t .= '<input type="text" name="__carrello__[__articoli__]['.$articolo.'][quantita]" value="'.$dati['quantita'].'" />';
            $t .= '</div>';
            $i++;
        }
        $t .= '<div><select name="__carrello__[provider_pagamento]">';
        foreach( $cf['ecommerce']['profile']['provider'] as $provider => $details ) {
            $t .= '<option ' . ( ( $provider === $_SESSION['carrello']['provider_pagamento'] ) ? 'selected="selected"' : NULL ) . ' value="' . $provider . '">' . $details['__label__'] . '</option>';
        }
        $t .= '</select></div>';
        $t .= '<button type="button" onclick="window.open(\'_acquisto.01.php\',\'_self\');">TORNA AGLI ACQUISTI</button>';
        $t .= '<button onclick="document.getElementById(\'carrello\').action = \'\'; document.getElementById(\'carrello\').submit();">AGGIORNA</button>';
        $t .= '<button type="submit">CONFERMA</button>';
        $t .= '</form>';
    } else {
        $t .= '<button type="button" onclick="window.open(\'_acquisto.01.php\',\'_self\');">TORNA AGLI ACQUISTI</button>';
    }

    // contenuto del carrello
    if( isset( $_SESSION['carrello'] ) ) {
        $t .= '<pre>' . print_r( $_SESSION['carrello'], true ) . '</pre>';
    } else {
        $t .= '<pre>CARRELLO VUOTO</pre>';
    }

    // output
    buildHTML( $t );
