<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     * @todo come agire nei controller before
     * @todo documentare
     *
     * @file
     *
     */

    // log
	logWrite( "controller default/before per ${t}/${a}", 'controller' );

    // debug
    // print_r( $vs );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:

            // debug
            // print_r( $vs );

            // converto il codice destinatario in id destinatario
            if( isset( $vs['codice_destinatario']['s'] ) ) {

                $vs['id_destinatario']['s'] = mysqlSelectValue( $c, 'SELECT id FROM anagrafica WHERE codice = ?', array( array( 's' => $vs['codice_destinatario']['s'] ) ) );
                $ks[] = 'id_destinatario';

                unset( $vs['codice_destinatario'] );
                removeFromArray( $ks, 'codice_destinatario' );

            }

            // converto il codice destinatario in id destinatario
            if( isset( $vs['codice_emittente']['s'] ) ) {

                $vs['id_emittente']['s'] = mysqlSelectValue( $c, 'SELECT id FROM anagrafica WHERE codice = ?', array( array( 's' => $vs['codice_emittente']['s'] ) ) );
                $ks[] = 'id_emittente';

                unset( $vs['codice_emittente'] );
                removeFromArray( $ks, 'codice_emittente' );

            }

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
					'SELECT id FROM documenti WHERE codice = ?',
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

    // debug
    // die( print_r( $p, true ) );
