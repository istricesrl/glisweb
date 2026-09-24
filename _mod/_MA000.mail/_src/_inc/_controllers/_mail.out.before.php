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

    // controllo azione corrente
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:

			if( array_key_exists( 'file', $d ) ) {
					
				$af = array();

				foreach( $d['file'] as $file ) {
					$af[] = $file['path'];
				}

				$vs['allegati'] = array( 's' => serialize( $af ) );
                if( ! in_array( 'allegati', $ks ) ) { $ks[] = 'allegati'; }

            } elseif ( isset( $vs['allegati'] ) ) {

				$vs['allegati'] = array( 's' => NULL);
                if( ! in_array( 'allegati', $ks ) ) { $ks[] = 'allegati'; }

			}

            // elaboro l'array dei valori
			foreach( $vs as $vKey => $vVal ) {

				if( in_array( $vKey, array( 'mittente', 'destinatari', 'destinatari_cc', 'destinatari_bcc' ) ) ) {
					$vs[ $vKey ]['s'] = serialize( mailString2array( $vVal['s'] ) ) ;
				}

			}

        break;

	}
