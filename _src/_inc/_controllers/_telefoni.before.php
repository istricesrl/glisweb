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

            // converto il codice anagrafica in id anagrafica
            if( isset( $vs['codice_anagrafica']['s'] ) ) {

                $vs['id_anagrafica']['s'] = mysqlSelectValue( $c, 'SELECT id FROM anagrafica WHERE codice = ?', array( array( 's' => $vs['codice_anagrafica']['s'] ) ) );
                $ks[] = 'id_anagrafica';

                unset( $vs['codice_anagrafica'] );
                removeFromArray( $ks, 'codice_anagrafica' );

            }

	    break;

	}

    // debug
    // die( print_r( $p, true ) );
