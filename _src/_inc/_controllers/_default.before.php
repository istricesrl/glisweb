<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     * @todo come agire nei controller before
     * @todo documentare
     *
     * @file
     *
     */

    // log
	logWrite( "controller default/before per ${t}/${a}", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:

		// elaboro l'array dei valori
		    foreach( $vs as $vKey => $vVal ) {

			// converto le timestamp in int
			    if( substr( $vKey, 0, 10 ) == 'timestamp_' && ( ! empty( $vVal['s'] ) && ! is_numeric( $vVal['s'] ) ) ) {
				$vs[ $vKey ]['s'] = strtotime( $vVal['s'] );
			    }

		    }

	    break;

	}

?>
