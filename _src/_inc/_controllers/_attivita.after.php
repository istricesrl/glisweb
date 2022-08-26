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
            #mysqlQuery( $c, 'CALL attivita_view_static( ? )', array( array( 's' => $d['id'] ) ) );
			mysqlQuery( $c, 'REPLACE INTO attivita_view_static SELECT * FROM attivita_view WHERE attivita_view.id = ' . $d['id'] );
            logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'speed' );
		break;
		case METHOD_DELETE:
			mysqlQuery( $c, 'DELETE FROM attivita_view_static WHERE attivita_view_static.id = ' . $d['id'] );
            logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'speed' );
        break;

	}
