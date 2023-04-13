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

    // controllo azione corrente
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:

			if( array_key_exists( 'file', $d )  ){
					
					$f = array();

					foreach( $d['file'] as $file ){
						$f[] = $file['path'];
					}

					$vs['allegati'] = array( 's' => serialize( $f ));
					
			} elseif ( isset( $vs['allegati'] )) {
				$vs['allegati'] = array( 's' => NULL);
			}
		
		
			// elaboro l'array dei valori
			foreach( $vs as $vKey => $vVal ) {

				if( in_array( $vKey, array( 'mittente', 'destinatari', 'destinatari_cc', 'destinatari_bcc' ) ) ) {
					$vs[ $vKey ]['s'] = serialize( mailString2array( $vVal['s'] ) ) ;
				}

			}

	    break;

	}
