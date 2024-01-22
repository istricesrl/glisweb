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
	logWrite( "controller before per ${t}/${a}", 'controller' );

    // controllo azione corrente
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:

			// NOTA se sto scrivendo la password, faccio l'hash; se sto leggendo i dati, elimino la password dai dati letti

			if( ! empty( $vs['id_periodicita']['s'] ) && ! empty( $vs['data_inizio']['s'] ) && empty( $vs['data_fine']['s'] ) ) {

				$delta = mysqlSelectValue( $c, 'SELECT giorni FROM periodicita WHERE id = ?', array( array( 's' => $vs['id_periodicita']['s'] ) ) );

				// var_dump( ' +' . $delta . ' days' );
				// var_dump( $vs['data_inizio']['s'] );
				// var_dump( date( 'Y-m-d', strtotime( ' +' . $delta . ' days', strtotime( $vs['data_inizio']['s'] ) ) ) );

				$vs['data_fine']['s'] = date( 'Y-m-d', strtotime( ' +' . $delta . ' days', strtotime( $vs['data_inizio']['s'] ) ) );
				if( ! in_array( 'data_fine', $ks ) ) {
					$ks[] = 'data_fine';
				}

				// die();

			}

	    break;

	}
