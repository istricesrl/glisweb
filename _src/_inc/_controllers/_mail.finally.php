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

    // debug
    // die( var_dump( $a ) );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

        case METHOD_DELETE:

            // print_r( $befores );
            // print_r( $_REQUEST );
            // $d['id_anagrafica'] = mysqlSelectValue( $c, 'SELECT id_anagrafica FROM mail WHERE id = ?', array( array( 's' => $d['id'] ) ) );
            // var_dump( $d['id'] );
            // var_dump( $d['id_anagrafica'] );
            // die( print_r( mysqlQuery( $c, 'SELECT * FROM anagrafica_view WHERE id = ?', array( array( 's' => $d['id_anagrafica'] ) ) ), true ) );

            if( isset( $befores['id_anagrafica'] ) ) {
                mysqlQuery( $c, 'REPLACE INTO anagrafica_view_static SELECT * FROM anagrafica_view WHERE id = ?', array( array( 's' => $befores['id_anagrafica'] ) ) );
                logWrite( 'aggiornata view statica ' . $t . '/anagrafica per id #' . $d['id'] . '/' . $befores['id_anagrafica'], 'static' );
            }

        break;

	}