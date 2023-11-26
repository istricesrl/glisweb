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

            // view statica naturale
            // mysqlQuery( $c, 'CALL corsi_view_static( ? )', array( array( 's' => $d['id'] ) ) );
            // print_r( mysqlQuery( $c, 'SELECT * FROM corsi_view WHERE id = ?', array( array( 's' => $d['id'] ) ) ) );

            // scrivo la riga
            updateReportLezioniCorsi( $d['id'] );

        break;
        case METHOD_DELETE:

            cleanReportLezioniCorsi();

        break;

	}
