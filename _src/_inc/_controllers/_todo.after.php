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
	logWrite( "controller after per ${t}/${a}", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:

            // view statica naturale
             #mysqlQuery( $c, 'CALL todo_view_static( ? )', array( array( 's' => $d['id'] ) ) );
			mysqlQuery( $c, 'REPLACE INTO todo_view_static SELECT * FROM todo_view WHERE todo_view.id = ' . $d['id'] );
            logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'speed' );

        break;
		
		case METHOD_DELETE:
			mysqlQuery( $c, 'DELETE FROM todo_view_static WHERE todo_view_static.id = ' . $d['id'] );
            logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'speed' );
		break;
		

	}
