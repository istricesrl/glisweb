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

            // scrivo la riga
            updateReportCorsi( $d['id_progetto'] );

        break;
        case METHOD_DELETE:

            // scrivo la riga
            updateReportCorsi( $d['id_progetto'] );

        break;

	}
