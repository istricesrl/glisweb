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
	logWrite( "controller before per ${t}/${a}", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:

            // ...
            if( empty( $vs['id_cliente']['s'] ) ) {
                if( ! empty( $vs['id_progetto']['s'] ) ) {
                    $vs['id_cliente']['s'] = mysqlSelectValue( $c, 'SELECT id_cliente FROM progetti WHERE id = ?', array( array( 's' => $vs['id_progetto']['s'] ) ) );
                    if( ! in_array( 'id_cliente', $ks ) ) { $ks[] = 'id_cliente'; }
                }
            }

            // ...
            if( empty( $vs['id_documenti_articoli']['s'] ) ) {
                if( ! empty( $vs['codice_documenti_articoli']['s'] ) ) {

                    $vs['id_documenti_articoli']['s'] = mysqlSelectValue( $c, 'SELECT id FROM documenti_articoli WHERE codice = ?', array( array( 's' => $vs['codice_documenti_articoli']['s'] ) ) );
                    if( ! in_array( 'id_documenti_articoli', $ks ) ) { $ks[] = 'id_documenti_articoli'; }

                    unset( $vs['codice_documenti_articoli'] );
                    removeFromArray( $ks, 'codice_documenti_articoli' );

                }
            }

        break;

    }
