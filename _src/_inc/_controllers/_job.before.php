<?php

    /**
     *
     *
     *
     *
     *
     *
     * @todo come agire nei controller append
     * @todo documentare
     *
     * @file
     *
     */

    // log
	logWrite( "controller job/before per ${t}/${a}", 'controller', LOG_DEBUG );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:

		// se ci sono dati specifici per il job
		    if( isset( $_REQUEST['__job__'] ) ) {

			// aggiungo la chiave 'workspace' ai dati da scrivere
			    $ks[] = 'workspace';

			// aggiungo il file al workspace
			    $vs['workspace']['s'] = json_encode( $_REQUEST['__job__'] );

		    }

	    break;

	}