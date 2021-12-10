<?php

    /**
     * controller pre query per la tabella account
     *
     *
     *
     * @file
     *
     */

    // log
	logWrite( "controller before per ${t}/${a}", 'controller' );
	
    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_GET:

		// se sono presenti dati
		    if( isset( $d ) && is_array( $d ) ) {


			// se i dati riguardano un singolo oggetto
			    if( in_array( 'id', $ks ) ) {

				// elaboro i campi
				    foreach( $d as $vKey => $vVal ) {

                        if( in_array( $vKey, array( 'mittente', 'destinatari', 'destinatari_cc', 'destinatari_bcc' ) ) ) {
                            $d[ $vKey ] = array2mailString( unserialize( $vVal ) ) ;
                        }
        
						if( in_array( $vKey, array( 'allegati' ) ) && !empty( $vVal ) ) {
							
							$file =  unserialize( $vVal );

							$d['file'] = array();

							$i = 1;
							foreach( $file as $f ){

								$d['file'][] =  array( 'path' => $f ,'ordine' => $i * 5, 'nome' => 'allegato mail #'.$i++, 'id_ruolo' => 1 ) ;

							}
                        }
				    }

			    } else {

				// elaboro l'intera collezione di oggetti
				    foreach( $d as &$row ) {

					// elaboro i campi
					    foreach( $row as $vKey => $vVal ) {

                            if( in_array( $vKey, array( 'mittente', 'destinatari', 'destinatari_cc', 'destinatari_bcc' ) ) ) {
                                $row[ $vKey ] = array2mailString( unserialize( $vVal ) ) ;
                            }
    
					    }

				    }

			    }

		    }

	    break;

	}
