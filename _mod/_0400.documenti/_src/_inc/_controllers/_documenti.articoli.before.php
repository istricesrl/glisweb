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

			if( isset( $vs['data_scadenza'] ) && isset( $vs['id_articolo'] ) ) {

				// die( $vs['data_scadenza']['s'] );

				// trovo l'ID della matricola
				$idMatricola = mysqlInsertRow(
					$c,
					array(
						'id' => NULL,
						'id_articolo' => $vs['id_articolo']['s'],
						'data_scadenza' => $vs['data_scadenza']['s'],
						'matricola' => str_replace( ',', NULL, microtime( true ) ),
						'nome' => 'matricola automatica per ' . $vs['id_articolo']['s'] . ' in scadenza il ' . $vs['data_scadenza']['s']
					),
					'matricole'
				);

				// die( $vs['id_articolo']['s'] );
				// var_dump( $idMatricola );
				// die( $idMatricola.PHP_EOL );

				unset( $vs['data_scadenza'] );
				removeFromArray( $ks, 'data_scadenza' );

				$ks[] = 'id_matricola';
				$vs['id_matricola']['s'] = $idMatricola;

				// die( print_r( $ks, true ) );
				// die( print_r( $vs, true ) );

			}

			if( isset( $vs['id_matricola']['s'] ) && ! empty( $vs['id_matricola']['s'] ) ) {

				$idArticolo = mysqlSelectValue(
					$c,
					'SELECT id_articolo FROM matricole WHERE id = ?',
					array( array( 's' => $vs['id_matricola']['s'] ) )
				);

				if( ! in_array( 'id_articolo', $ks ) ) {
					$ks[] = 'id_articolo';
				}

				$vs['id_articolo']['s'] = $idArticolo;

			}

			// die( __FILE__ );

		break;

	}
