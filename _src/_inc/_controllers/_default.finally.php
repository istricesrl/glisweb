<?php

    /**
     *
     *
     *
     *
     *
     *
     * @todo come agire nei controller finally
     * @todo documentare
     *
     * @file
     *
     */

    // log
	logWrite( "controller default/finally per ${t}/${a}", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:
			
		// applicazione delle regole di attribuzione automatica
		    if( isset( $_SESSION['account']['id_gruppi_attribuzione'][ $t ] ) ) {

			// debug
			    // print_r( $_SESSION['account']['id_gruppi_attribuzione'][ $t ] );
			    

			// attribuzione automatica
			// TODO anziché FULL di ufficio consentire di specificare permessi diversi
			    foreach( $_SESSION['account']['id_gruppi_attribuzione'][ $t ] as $aGrId ) {
				$q = "REPLACE INTO __acl_${t}__ ( id_entita, id_gruppo, permesso ) VALUES ( ?, ?, 'FULL' )";
				mysqlQuery( $c, $q, array( array( 's' => $d['id'] ), array( 's' => $aGrId ) ) );
			    }

		    }

		// invalidazione della cache per l'entità corrente
		    memcacheCleanFromIndex( $t );

	    break;

	}
