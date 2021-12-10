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
    $i = 0;

    // form di esempio per l'acquisto di un prodotto
    if( isset( $_SESSION['carrello']['articoli'] ) ) {
        $t .= '<form action="_acquisto.03.php" method="POST">';
        $t .= '<div>';
        $t .= 'NOME';
        $t .= '<input type="text" name="__carrello__[intestazione_nome]" value="'.$_SESSION['carrello']['intestazione_nome'].'" />';
        $t .= '</div>';
        foreach( $_SESSION['carrello']['articoli'] as $articolo => $dati ) {
            $t .= '<div>';
            $t .= '<input type="hidden" name="__carrello__[__articoli__]['.$i.'][id_articolo]" value="'.$dati['id_articolo'].'" />';
            $t .= $dati['id_articolo'];
            $t .= '<input type="text" name="__carrello__[__articoli__]['.$i.'][quantita]" value="'.$dati['quantita'].'" />';
            $t .= '</div>';
            $i++;
        }
        $t .= '<button type="button" onclick="window.open(\'_acquisto.01.php\',\'_self\');">TORNA AGLI ACQUISTI</button>';
        $t .= '<button type="submit">CONFERMA</button>';
        $t .= '</form>';
    } else {
        $t .= '<button type="button" onclick="window.open(\'_acquisto.01.php\',\'_self\');">TORNA AGLI ACQUISTI</button>';
    }

    // contenuto del carrello
    if( isset( $_SESSION['carrello'] ) ) {
        $t .= '<pre>' . print_r( $_SESSION['carrello'], true ) . '</pre>';
    }

    // output
    buildHTML( $t );
