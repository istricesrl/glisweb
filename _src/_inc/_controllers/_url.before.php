<?php

    /**
     * controller pre query per la tabella url
     *
     * In scrittura converte codice_anagrafica in id_anagrafica, come gli altri controller before di questa cartella, e
     * se il campo password arriva vuoto lo toglie dalla query, così che salvare la scheda senza ridigitare la password
     * non la cancelli. La password dell'URL è una credenziale da rileggere per accedere al servizio, non quella di un
     * account: si salva in chiaro, e qui non se ne fa nessun hash.
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

			// una password vuota non sovrascrive quella salvata
			if( empty( $vs['password']['s'] ) ) {
				unset( $vs['password'] );
				removeFromArray( $ks, 'password' );
			}

	    break;

	}
