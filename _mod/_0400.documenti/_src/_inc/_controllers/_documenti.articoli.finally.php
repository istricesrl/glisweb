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

            // view statica naturale
            // mysqlQuery( $c, 'CALL documenti_articoli_view_static( ? )', array( array( 's' => $d['id'] ) ) );
            refreshStaticView( $c, 'documenti_articoli', $d['id'] );
            logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'speed' );

        break;
        case METHOD_DELETE:

            // la statica di documenti_articoli non esiste in nessun deploy: la DELETE secca dava 1146 a ogni cancellazione
            if( ! empty( getStaticView( NULL, $c, 'documenti_articoli' ) ) ) {

                mysqlQuery( $c, 'DELETE FROM documenti_articoli_view_static WHERE id = ?', array( array( 's' => $d['id'] ) ) );
                logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'speed' );

            }

        break;

    }
