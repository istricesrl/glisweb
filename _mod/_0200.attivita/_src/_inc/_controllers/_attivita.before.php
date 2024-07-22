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

            // ...
            if( empty( $vs['id_todo']['s'] ) ) {
                if( ! empty( $vs['codice_todo']['s'] ) ) {

                    $vs['id_todo']['s'] = mysqlSelectValue( $c, 'SELECT id FROM todo WHERE codice = ?', array( array( 's' => $vs['codice_todo']['s'] ) ) );
                    if( ! in_array( 'id_todo', $ks ) ) { $ks[] = 'id_todo'; }

                    unset( $vs['codice_todo'] );
                    removeFromArray( $ks, 'codice_todo' );

                }
            }

            // ...
            if( empty( $vs['id_tipologia']['s'] ) ) {
                if( ! empty( $vs['codice_tipologia']['s'] ) ) {

                    $vs['id_tipologia']['s'] = mysqlSelectValue( $c, 'SELECT id FROM tipologie_attivita WHERE codice = ?', array( array( 's' => $vs['codice_tipologia']['s'] ) ) );
                    if( ! in_array( 'id_tipologia', $ks ) ) { $ks[] = 'id_tipologia'; }

                    unset( $vs['codice_tipologia'] );
                    removeFromArray( $ks, 'codice_tipologia' );

                }
            }

            // ...
            if( empty( $vs['id_asset']['s'] ) ) {
                if( ! empty( $vs['codice_asset']['s'] ) ) {

                    $vs['id_asset']['s'] = mysqlSelectValue( $c, 'SELECT id FROM asset WHERE codice = ?', array( array( 's' => $vs['codice_asset']['s'] ) ) );
                    if( ! in_array( 'id_asset', $ks ) ) { $ks[] = 'id_asset'; }

                    unset( $vs['codice_asset'] );
                    removeFromArray( $ks, 'codice_asset' );

                }
            }

            // ...
            if( empty( $vs['id_anagrafica']['s'] ) ) {
                if( ! empty( $vs['codice_operatore']['s'] ) ) {

                    $vs['id_anagrafica']['s'] = mysqlSelectValue( $c, 'SELECT id FROM anagrafica WHERE codice = ?', array( array( 's' => $vs['codice_operatore']['s'] ) ) );
                    if( ! in_array( 'id_anagrafica', $ks ) ) { $ks[] = 'id_anagrafica'; }

                    unset( $vs['codice_operatore'] );
                    removeFromArray( $ks, 'codice_operatore' );

                } elseif( ! empty( $vs['id_contratto']['s'] ) ) {

                    $vs['id_anagrafica']['s'] = mysqlSelectValue( $c, 'SELECT id_anagrafica FROM contratti_anagrafica WHERE id_contratto = ? AND id_ruolo IN (29,32,33,34)', array( array( 's' => $vs['id_contratto']['s'] ) ) );
                    if( ! in_array( 'id_anagrafica', $ks ) ) { $ks[] = 'id_anagrafica'; }

                } else {

                    unset( $vs['codice_operatore'] );
                    removeFromArray( $ks, 'codice_operatore' );

                }
            }

        break;

	}
