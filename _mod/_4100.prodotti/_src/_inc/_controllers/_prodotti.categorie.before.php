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
            if( isset( $vs['codice_prodotto']['s'] ) ) {

                $vs['id_prodotto']['s'] = $vs['codice_prodotto']['s'];
                $ks[] = 'id_prodotto';

                unset( $vs['codice_prodotto'] );
                removeFromArray( $ks, 'codice_prodotto' );

            }

            // converto il codice destinatario in id destinatario
            if( isset( $vs['codice_categoria']['s'] ) ) {

                $vs['id_categoria']['s'] = mysqlSelectValue( $c, 'SELECT id FROM categorie_prodotti WHERE codice = ?', array( array( 's' => $vs['codice_categoria']['s'] ) ) );
                $ks[] = 'id_categoria';

                unset( $vs['codice_categoria'] );
                removeFromArray( $ks, 'codice_categoria' );

            }

	    break;

    }

    // debug
    // die( print_r( $p, true ) );
