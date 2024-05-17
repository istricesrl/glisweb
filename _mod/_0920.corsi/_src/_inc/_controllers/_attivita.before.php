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
	logWrite( "controller finally per ${t}/${a}", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:

            if( isset( $d['__prenotazione_abbonamento__'] ) && ! empty( $d['__prenotazione_abbonamento__'] ) ) {
                if( empty( $vs['id_anagrafica']['s'] ) ) {
                    if( ! empty( $vs['id_contratto']['s'] ) ) {
                        $vs['id_anagrafica']['s'] = mysqlSelectValue( $c, 'SELECT id_anagrafica FROM contratti_anagrafica WHERE id_contratto = ? AND id_ruolo = 34', array( array( 's' => $vs['id_contratto']['s'] ) ) );
                        if( ! in_array( 'id_anagrafica', $ks ) ) { $ks[] = 'id_anagrafica'; }
                    }
                }
            }

            // ...
            // echo 'prova';
            // print_r( $vs );
            // die( print_r( $d, true ) );

        break;
        case METHOD_DELETE:

            // ...

        break;

	}
