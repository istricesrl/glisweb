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

    // debug
    // print_r( $vs );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:

            // debug
            // print_r( $vs );

            // converto il codice destinatario in id destinatario
            if( isset( $vs['codice_istruzione']['s'] ) ) {

                $vs['id_istruzione']['s'] = mysqlSelectValue( $c, 'SELECT id FROM istruzioni WHERE codice = ?', array( array( 's' => $vs['codice_istruzione']['s'] ) ) );
                $ks[] = 'id_istruzione';

                unset( $vs['codice_istruzione'] );
                removeFromArray( $ks, 'codice_istruzione' );

            }

            // converto il codice destinatario in id destinatario
            if( isset( $vs['codice_tipologia_attivita']['s'] ) ) {

                $vs['id_tipologia_attivita']['s'] = mysqlSelectValue( $c, 'SELECT id FROM tipologie_attivita WHERE codice = ?', array( array( 's' => $vs['codice_tipologia_attivita']['s'] ) ) );
                $ks[] = 'id_tipologia_attivita';

                unset( $vs['codice_tipologia_attivita'] );
                removeFromArray( $ks, 'codice_tipologia_attivita' );

            }

	    break;

    }

    // debug
    // die( print_r( $p, true ) );
