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
            mysqlQuery( $c, 'REPLACE INTO corsi_view_static SELECT * FROM corsi_view WHERE id = ?', array( array( 's' => $d['id'] ) ) );
            logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'static' );

            // scrivo la riga
            updateReportCorsi( $d['id'] );

        break;
        case METHOD_DELETE:

            mysqlQuery( $c, 'DELETE FROM corsi_view_static WHERE id = ?', array( array( 's' => $d['id'] ) ) );
            logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'static' );

            cleanReportCorsi();

        break;

	}
