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
	logWrite( "controller finally per $t/$a", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:
        case METHOD_DELETE:

            // corsi toccati dalla scrittura: su DELETE $d non porta id_progetto, lo si prende dalla riga com'era prima
            $idCorsi = array_unique( array_filter( array(
                ( isset( $befores['id_progetto'] ) ) ? $befores['id_progetto'] : NULL,
                ( isset( $d['id_progetto'] ) ) ? $d['id_progetto'] : NULL
            ) ) );

            // scrivo la riga, solo per un corso noto: con l'id vuoto l'INSERT su __report_corsi__ dava 1048
            foreach( $idCorsi as $idCorso ) {
                updateReportCorsi( $idCorso );
            }

        break;

	}
