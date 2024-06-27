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

            // converto il codice destinatario in id destinatario
            if( array_key_exists( 'codice_documenti_articoli', $vs ) ) {

				// TODO implementare
                // $vs['id_destinatario']['s'] = mysqlSelectValue( $c, 'SELECT id FROM anagrafica WHERE codice = ?', array( array( 's' => $vs['codice_destinatario']['s'] ) ) );
                // $ks[] = 'id_destinatario';

                unset( $vs['codice_documenti_articoli'] );
                removeFromArray( $ks, 'codice_documenti_articoli' );

            }

            // ...
            if( empty( $vs['id_documento']['s'] ) ) {
                if( ! empty( $vs['codice_documento']['s'] ) ) {

                    $vs['id_documento']['s'] = mysqlSelectValue( $c, 'SELECT id FROM documenti WHERE codice = ?', array( array( 's' => $vs['codice_documento']['s'] ) ) );
                    if( ! in_array( 'id_documento', $ks ) ) { $ks[] = 'id_documento'; }

                    unset( $vs['codice_documento'] );
                    removeFromArray( $ks, 'codice_documento' );

                } else {

                    unset( $vs['codice_documento'] );
                    removeFromArray( $ks, 'codice_documento' );

                }
            }

            // die( __FILE__ );

        break;

	    case METHOD_DELETE:

            // log
            logWrite( "controller before per ${t}/${a} metodo DELETE", 'controller', LOG_ERR );

            logWrite( print_r( $vs, true ), 'controller', LOG_ERR );
            logWrite( print_r( $ks, true ), 'controller', LOG_ERR );

            if( isset( $vs['codice'] ) && ( ! isset( $vs['id'] ) || empty( $vs['id']['s'] ) ) ) {

                logWrite( "controller before per ${t}/${a} metodo DELETE per CODICE anziché per ID", 'controller', LOG_ERR );

                $id = mysqlSelectValue(
					$c,
					'SELECT id FROM documenti_articoli WHERE codice = ?',
					array( array( 's' => $vs['codice']['s'] ) )
				);

				if( ! in_array( 'id', $ks ) ) {
					$ks[] = 'id';
				}

				$vs['id']['s'] = $id;

                unset( $vs['codice'] );
                removeFromArray( $ks, 'codice' );

                logWrite( print_r( $vs, true ), 'controller', LOG_ERR );
                logWrite( print_r( $ks, true ), 'controller', LOG_ERR );

            }

        break;

    }
