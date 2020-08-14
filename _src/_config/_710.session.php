<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // NOTA
	// questa logica potrebbe sembrare fuori posto qui, perché si tratta sempre di
	// gestione dati (e quindi competenza del controller) anche se sotto chiavi
	// speciali; ma da un altro punto di vista si tratta di una vera e propria
	// gestione della sessione, e la coerenza con la gestione dei blocchi dati è
	// garantita dall'inserimento nel blocco _7xx

    // inizializzo l'array della view
	if( ! isset( $_SESSION['__view__'] ) ) {
	    $_SESSION['__view__'] = array();
	}

    // defaults
	if( ! isset( $_SESSION['__view__']['__site__'] ) ) {
	    $_SESSION['__view__']['__site__'] = SITE_CURRENT;
	}

    // debug
	// print_r( $_REQUEST );
	// print_r( $_SESSION );
	// print_r( $cf['contents']['pages']['licenza']['content'] );

?>
