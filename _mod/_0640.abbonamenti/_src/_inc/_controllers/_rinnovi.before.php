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

    /* NOTA doppione della controller rinnovi before del modulo contratti

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:

            // ...
            if( empty( $vs['data_fine']['s'] ) ) {
                if( ! empty( $vs['data_inizio']['s'] ) ) {
                    if( ! empty( $vs['id_periodicita']['s'] ) ) {
                        if( true ) {
                            $giorni = mysqlSelectValue( $c, 'SELECT giorni FROM periodicita WHERE id = ?', array( array( 's' => $vs['id_periodicita']['s'] ) ) );
                            $vs['data_fine']['s'] = date( 'Y-m-d', strtotime( $vs['data_inizio']['s'] . '+' . $giorni . ' days' ) );
                            if( ! in_array( 'data_fine', $ks ) ) { $ks[] = 'data_fine'; }
                        }
                    }
                }
            }

        break;

    }

    */
