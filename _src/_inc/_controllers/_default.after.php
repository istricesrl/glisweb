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
	logWrite( "controller default/after per ${t}/${a}", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_GET:

		// se sono presenti dati
		    if( isset( $d ) && is_array( $d ) ) {

				// se i dati riguardano un singolo oggetto
			    if( in_array( 'id', $ks ) ) {

				// elaboro i campi
				    foreach( $d as $vKey => $vVal ) {

					// converto le timestamp in date
					    if( substr( $vKey, 0, 10 ) == 'timestamp_' && ! empty( $vVal ) ) {
						$d[ $vKey ] = date( 'Y-m-d\TH:i', $vVal );
					    }

				    }

			    } else {

				// elaboro l'intera collezione di oggetti
				    foreach( $d as &$row ) {

					// elaboro i campi
					    foreach( $row as $vKey => $vVal ) {

						// converto le timestamp in date
						    if( substr( $vKey, 0, 10 ) == 'timestamp_' && ! empty( $vVal ) ) {
							$row[ $vKey ] = date( 'Y-m-d\TH:i', $vVal );
						    }

					    }

				    }

			    }

		    }

	    break;

	}
