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
            if( empty( $d['id_progetto'] ) ) {
                if( ! empty( $d['id_mastro_destinazione'] ) ) {
                    $d['id_progetto'] = mysqlSelectValue( $c, 'SELECT id_progetto FROM mastri WHERE id = ?', array( array( 's' => $d['id_mastro_destinazione'] ) ) );
                } elseif( ! empty( $d['id_mastro_provenienza'] ) ) {
                    $d['id_progetto'] = mysqlSelectValue( $c, 'SELECT id_progetto FROM mastri WHERE id = ?', array( array( 's' => $d['id_mastro_provenienza'] ) ) );
                } elseif( ! empty( $d['id_todo'] ) ) {
                    $d['id_progetto'] = mysqlSelectValue( $c, 'SELECT id_progetto FROM todo WHERE id = ?', array( array( 's' => $d['id_todo'] ) ) );
                }
            }

            // ...
            if( empty( $d['id_cliente'] ) ) {
                if( ! empty( $d['id_progetto'] ) ) {
                    $d['id_cliente'] = mysqlSelectValue( $c, 'SELECT id_cliente FROM progetti WHERE id = ?', array( array( 's' => $d['id_progetto'] ) ) );
                }
            }

        break;

	}
