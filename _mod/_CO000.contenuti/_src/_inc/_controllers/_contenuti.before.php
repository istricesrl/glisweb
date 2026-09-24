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

            // elaboro l'array dei valori
			foreach( $vs as $vKey => $vVal ) {

				if( in_array( $vKey, array( 'mittente_mail', 'destinatari_mail', 'destinatari_cc_mail', 'destinatari_bcc_mail' ) ) ) {
					$vs[ $vKey ]['s'] = serialize( mailString2array( $vVal['s'] ) ) ;
				}

			}

            // forzo la formattazione dell'HTML nel campo testo
            if( isset( $vs['testo']['s'] ) ) {

                $config = [
                    'indent'         => true,
                    'indent-spaces'  => 4,
                    'wrap'           => 0,
                    'show-body-only' => true,
                    'drop-empty-elements' => false,
                    'newline'        => 'LF',
                    'output-xhtml'   => false,
                    'output-html'    => true,
                    'quiet'          => true,
                ];

                $tidy = new tidy();
                $tidy->parseString('<!doctype html><html><body>' . $vs['testo']['s'] . '</body></html>', $config, 'utf8');
                $tidy->cleanRepair();

                $vs['testo']['s'] = trim((string)$tidy);

            }

        break;

	}
