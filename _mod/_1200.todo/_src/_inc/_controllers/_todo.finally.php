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

            // view statica naturale
            // mysqlQuery( $c, 'CALL todo_view_static( ? )', array( array( 's' => $d['id'] ) ) );
            mysqlQuery( $c, 'REPLACE INTO todo_view_static SELECT * FROM todo_view WHERE id = ?', array( array( 's' => $d['id'] ) ) );
            logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'speed' );

        break;
        case METHOD_DELETE:

            mysqlQuery( $c, 'DELETE FROM todo_view_static WHERE id = ?', array( array( 's' => $d['id'] ) ) );
            logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'speed' );

        break;

	}
