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
        
						if( in_array( $vKey, array( 'allegati' ) ) && !empty( $d[ 'allegati' ]) ) {
							
							if( !isset( $d['file']) || ( isset( $d['file'] ) && count(  unserialize( $vVal ) ) != count( $d['file'] ) ) ){
								
								$file =  unserialize( $vVal );
							
								if( !isset($d['file']) ){ $d['file'] = array(); }
								
								$counter = 1;
								
								foreach( $file as $f ){

										$d['file'][] =  array( 'path' => $f ,'ordine' => $counter * 5, 'nome' => 'allegato mail #'.$counter++, 'id_ruolo' => 1 ) ;	
									
								}
							}

							
                        }
				    }

			    } 

		    }

	    break;

	}
