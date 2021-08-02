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
            mysqlQuery( $c, 'CALL anagrafica_view_static( ? )', array( array( 's' => $p ) ) );
            logWrite( 'aggiornata view statica ' . $t . ' per id_anagrafica #' . $p, 'speed' );

        break;

	}
