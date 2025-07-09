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
	 			// die( print_r( $vs, true ) );

			} elseif( isset( $vs['id_periodo']['s'] ) && ! empty( $vs['id_periodo']['s'] ) ) {

				// seleziono il periodo
				$periodo = mysqlSelectRow( $c, 'SELECT * FROM periodi WHERE id = ?', array( array( 's' => $vs['id_periodo']['s'] ) ) );

				// limito la data fine al periodo indicato
				if( ! empty( $periodo['data_fine'] ) && strtotime( $vs['data_fine']['s'] ) > strtotime( $periodo['data_fine'] ) ) {
					$vs['data_fine']['s'] = $periodo['data_fine'];
				} else {
					$vs['data_fine']['s'] = date( 'Y-m-d', strtotime( ' +' . $delta . ' days', strtotime( $vs['data_inizio']['s'] ) ) );
				}

				if( ! in_array( 'data_fine', $ks ) ) {
					$ks[] = 'data_fine';
				}

				// die();
	 			// die( print_r( $vs, true ) );

			}


	    break;

	}
