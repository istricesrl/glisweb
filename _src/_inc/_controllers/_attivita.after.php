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
        case METHOD_DELETE:

            // view statica naturale
            mysqlQuery( $c, 'CALL attivita_view_static( ? )', array( array( 's' => $d['id'] ) ) );
            logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'speed' );

        break;

	}
