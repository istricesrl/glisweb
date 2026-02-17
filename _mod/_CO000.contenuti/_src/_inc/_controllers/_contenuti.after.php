<?php

    /**
     * controller pre query per la tabella account
     *
     *
     *
     * 
     *
     */

    // log
	logWrite( "controller before per $t/$a", 'controller' );
	
    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_GET:

			// se sono presenti dati
		    if( isset( $d ) && is_array( $d ) ) {

				// se i dati riguardano un singolo oggetto
			    if( in_array( 'id', $ks ) ) {
					
					// elaboro i campi
				    foreach( $d as $vKey => $vVal ) {

                        if( in_array( $vKey, array( 'mittente_mail', 'destinatari_mail', 'destinatari_cc_mail', 'destinatari_bcc_mail' ) ) ) {
                            if( ! empty( $vVal ) ) {
                                $d[ $vKey ] = array2mailString( unserialize( $vVal ) ) ;
                            }
                        }

					}

			    } else {

					// elaboro l'intera collezione di oggetti
				    foreach( $d as &$row ) {

						// elaboro i campi
					    foreach( $row as $vKey => $vVal ) {

                            if( in_array( $vKey, array( 'mittente_mail', 'destinatari_mail', 'destinatari_cc_mail', 'destinatari_bcc_mail' ) ) ) {
                                if( ! empty( $vVal ) ) {
                                    $row[ $vKey ] = array2mailString( unserialize( $vVal ) ) ;
                                }
                            }

					    }

				    }

			    }

		    }

	    break;

	}
