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

            // ...
            if( empty( $vs['id_progetto']['s'] ) ) {
                if( ! empty( $vs['id_mastro_destinazione']['s'] ) ) {
                    $vs['id_progetto']['s'] = mysqlSelectValue( $c, 'SELECT id_progetto FROM mastri WHERE id = ?', array( array( 's' => $vs['id_mastro_destinazione']['s'] ) ) );
                    if( ! in_array( 'id_progetto', $ks ) ) { $ks[] = 'id_progetto'; }
                } elseif( ! empty( $vs['id_mastro_provenienza']['s'] ) ) {
                    $vs['id_progetto']['s'] = mysqlSelectValue( $c, 'SELECT id_progetto FROM mastri WHERE id = ?', array( array( 's' => $vs['id_mastro_provenienza']['s'] ) ) );
                    if( ! in_array( 'id_progetto', $ks ) ) { $ks[] = 'id_progetto'; }
                } elseif( ! empty( $vs['id_todo']['s'] ) ) {
                    $vs['id_progetto']['s'] = mysqlSelectValue( $c, 'SELECT id_progetto FROM todo WHERE id = ?', array( array( 's' => $vs['id_todo']['s'] ) ) );
                    if( ! in_array( 'id_progetto', $ks ) ) { $ks[] = 'id_progetto'; }
                }
            }

            // ...
            if( empty( $vs['id_cliente']['s'] ) ) {
                if( ! empty( $vs['id_progetto']['s'] ) ) {
                    $vs['id_cliente']['s'] = mysqlSelectValue( $c, 'SELECT id_cliente FROM progetti WHERE id = ?', array( array( 's' => $vs['id_progetto']['s'] ) ) );
                    if( ! in_array( 'id_cliente', $ks ) ) { $ks[] = 'id_cliente'; }
                }
            }

            // ...
            if( ! empty( $vs['id_todo']['s'] ) ) {
                if( empty( $vs['data_programmazione']['s'] ) ) {
                    $vs['data_programmazione']['s'] = mysqlSelectValue( $c, 'SELECT data_programmazione FROM todo WHERE id = ?', array( array( 's' => $vs['id_todo']['s'] ) ) );
                    if( ! in_array( 'data_programmazione', $ks ) ) { $ks[] = 'data_programmazione'; }
                }
                if( empty( $vs['ora_inizio_programmazione']['s'] ) ) {
                    $vs['ora_inizio_programmazione']['s'] = mysqlSelectValue( $c, 'SELECT ora_inizio_programmazione FROM todo WHERE id = ?', array( array( 's' => $vs['id_todo']['s'] ) ) );
                    if( ! in_array( 'ora_inizio_programmazione', $ks ) ) { $ks[] = 'ora_inizio_programmazione'; }
                }
                if( empty( $vs['ora_fine_programmazione']['s'] ) ) {
                    $vs['ora_fine_programmazione']['s'] = mysqlSelectValue( $c, 'SELECT ora_fine_programmazione FROM todo WHERE id = ?', array( array( 's' => $vs['id_todo']['s'] ) ) );
                    if( ! in_array( 'ora_fine_programmazione', $ks ) ) { $ks[] = 'ora_fine_programmazione'; }
                }
            }

        break;

	}
