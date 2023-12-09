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
        case METHOD_DELETE:

            // ...
            // die( print_r( $befores, true ) );
            // die( print_r( $afters, true ) );

            // ...
            if( isset( $befores['id_articolo'] ) ) {
                if( isset( $befores['id_mastro_destinazione'] ) && ! empty( $befores['id_mastro_destinazione'] ) ) {
                    updateReportGiacenzaMagazzini( $befores['id_mastro_destinazione'], $befores['id_articolo'], ( ( isset( $befores['id_matricola'] ) && ! empty( $befores['id_matricola'] ) ) ? $befores['id_matricola'] : NULL ) );
                }
                if( isset( $befores['id_mastro_provenienza'] ) && ! empty( $befores['id_mastro_provenienza'] ) ) {
                    updateReportGiacenzaMagazzini( $befores['id_mastro_provenienza'], $befores['id_articolo'], ( ( isset( $befores['id_matricola'] ) && ! empty( $befores['id_matricola'] ) ) ? $befores['id_matricola'] : NULL ) );
                }
            }

            // ...
            if( isset( $afters['id_articolo'] ) ) {
                if( isset( $afters['id_mastro_destinazione'] ) && ! empty( $afters['id_mastro_destinazione'] ) ) {
                    updateReportGiacenzaMagazzini( $afters['id_mastro_destinazione'], $afters['id_articolo'], ( ( isset( $afters['id_matricola'] ) && ! empty( $afters['id_matricola'] ) ) ? $afters['id_matricola'] : NULL ) );
                }
                if( isset( $afters['id_mastro_provenienza'] ) && ! empty( $afters['id_mastro_provenienza'] ) ) {
                    updateReportGiacenzaMagazzini( $afters['id_mastro_provenienza'], $afters['id_articolo'], ( ( isset( $afters['id_matricola'] ) && ! empty( $afters['id_matricola'] ) ) ? $afters['id_matricola'] : NULL ) );
                }
            }

            // ...
            // print_r( $befores );
            // print_r( $afters );
            // die();

        break;

	}

    // debug
    // die( print_r( $p, true ) );
