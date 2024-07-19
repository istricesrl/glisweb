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

    // rimpiazzo le parentesi tonde con le parentesi quadre
    $_REQUEST['__delete__']['target'] = str_replace( array( '(', ')' ), array( '[', ']' ), $_REQUEST['__delete__']['target'] );
    $_REQUEST['__delete__']['rollback'] = str_replace( array( '(', ')' ), array( '[', ']' ), $_REQUEST['__delete__']['rollback'] );

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

        // ...
        $rm = getStaticViewExtension( $cf['memcache']['connection'], $cf['mysql']['connection'], $_REQUEST['__delete__']['table'] );

        // recupero la __label__ dell'oggetto da cancellare
        // TODO ma questo non ci espone a SQL injection?
        // NOTA ma non è che anche nella controller c'è questo problema? $t viene mai filtrato?
	    $ct['__delete__']['__label__'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT __label__ FROM ' . $_REQUEST['__delete__']['table'] . $rm . ' WHERE id = ? LIMIT 1', array(
		    array( 's' => $_REQUEST['__delete__']['id'] )
	    ) );

        // timer
        timerCheck( $cf['speed'], 'fine recupero dati oggetto da cancellare' );

    }
