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
            if( empty( $vs['id_progetto']['s'] ) ) {
                if( ! empty( $vs['id_mastro_destinazione']['s'] ) ) {
                    $vs['id_progetto']['s'] = mysqlSelectValue( $c, 'SELECT id_progetto FROM mastri WHERE id = ?', array( array( 's' => $vs['id_mastro_destinazione']['s'] ) ) );
                    $ks[] = 'id_cliente';
                } elseif( ! empty( $vs['id_mastro_provenienza']['s'] ) ) {
                    $vs['id_progetto']['s'] = mysqlSelectValue( $c, 'SELECT id_progetto FROM mastri WHERE id = ?', array( array( 's' => $vs['id_mastro_provenienza']['s'] ) ) );
                    $ks[] = 'id_cliente';
                } elseif( ! empty( $vs['id_todo']['s'] ) ) {
                    $vs['id_progetto']['s'] = mysqlSelectValue( $c, 'SELECT id_progetto FROM todo WHERE id = ?', array( array( 's' => $vs['id_todo']['s'] ) ) );
                    $ks[] = 'id_cliente';
                }
            }

            // ...
            if( empty( $vs['id_cliente']['s'] ) ) {
                if( ! empty( $vs['id_progetto']['s'] ) ) {
                    $vs['id_cliente']['s'] = mysqlSelectValue( $c, 'SELECT id_cliente FROM progetti WHERE id = ?', array( array( 's' => $vs['id_progetto']['s'] ) ) );
                    $ks[] = 'id_cliente';
                }
            }

        break;

	}
