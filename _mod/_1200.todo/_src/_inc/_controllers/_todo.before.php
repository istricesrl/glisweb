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
	logWrite( "controller finally per ${t}/${a}", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:

            // ...
            if( empty( $d['id_cliente'] ) ) {
                if( ! empty( $d['id_progetto'] ) ) {
                    $d['id_cliente'] = mysqlSelectValue( $c, 'SELECT id_cliente FROM progetti WHERE id = ?', array( array( 's' => $d['id_progetto'] ) ) );
                }
            }

        break;

    }
