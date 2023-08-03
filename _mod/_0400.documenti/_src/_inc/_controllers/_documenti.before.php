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

	}

    // debug
    // die( print_r( $p, true ) );
