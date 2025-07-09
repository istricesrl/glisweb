<?php

    /**
     * controller pre query per la tabella account
     *
     *
     *
     * @file
     *
     */

    // log
	logWrite( "controller before per $t/$a", 'controller' );

    // controllo azione corrente
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:

            // converto il codice anagrafica in id anagrafica
            if( isset( $vs['codice_anagrafica']['s'] ) ) {

                $vs['id_anagrafica']['s'] = mysqlSelectValue( $c, 'SELECT id FROM anagrafica WHERE codice = ?', array( array( 's' => $vs['codice_anagrafica']['s'] ) ) );
                $ks[] = 'id_anagrafica';

                unset( $vs['codice_anagrafica'] );
                removeFromArray( $ks, 'codice_anagrafica' );

            }

			// NOTA se sto scrivendo la password, faccio l'hash; se sto leggendo i dati, elimino la password dai dati letti

			if( empty( $vs['password']['s'] ) ) {
				unset( $vs['password'] );
				removeFromArray( $ks, 'password' );
			}

	    break;

	}
