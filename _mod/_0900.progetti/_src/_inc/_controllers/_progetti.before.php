<?php

    /**
     *
     *
     *
     *
     *
     *
     * @todo come agire nei controller after
     * @todo documentare
     *
     * @file
     *
     */

    // log
	logWrite( "controller before per ${t}/${a}", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:

            // ...
            if( empty( $vs['id_cliente']['s'] ) ) {
                if( ! empty( $vs['codice_cliente']['s'] ) ) {

                    $vs['id_cliente']['s'] = mysqlSelectValue( $c, 'SELECT id FROM anagrafica WHERE codice = ?', array( array( 's' => $vs['codice_cliente']['s'] ) ) );
                    if( ! in_array( 'id_cliente', $ks ) ) { $ks[] = 'id_cliente'; }

                    unset( $vs['codice_cliente'] );
                    removeFromArray( $ks, 'codice_cliente' );

                }
            }

        break;

	}
