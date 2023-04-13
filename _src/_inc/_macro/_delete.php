<?php

    /**
     * macro di cancellazione
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // richiesta o conferma
    if( isset( $_REQUEST['__delete__']['conferma'] ) && $_REQUEST['__delete__']['conferma'] == 1 ) {

	// recupero eventuali errori di cancellazione
	    // TODO se ci sono errori non lanciare l'header ma passare gli errori alla pagina

	// debug
	    // session_write_close();
	    // print_r( ob_get_status( true ) );

        // ritorno alla pagina richiedente
	    header( 'Location: '.$_REQUEST['__delete__']['target'] );

	// status code che indica la redirezione
	    $ct['page']['http']['status'] = 303;

	// debug
	    // print_r( $_REQUEST );
	    // if( headers_sent( $file, $line ) ) { echo $file . '->' . $line; } else { echo 'output non iniziato'; }

    } else {

	// recupero la __label__ dell'oggetto da cancellare
	    $ct['__delete__']['__label__'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT __label__ FROM ' . $_REQUEST['__delete__']['table'] . '_view WHERE id = ? LIMIT 1', array(
		    array( 's' => $_REQUEST['__delete__']['id'] )
	    ) );

    }
