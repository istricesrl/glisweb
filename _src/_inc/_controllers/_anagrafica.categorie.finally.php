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
	logWrite( "controller finally per ${t}/${a}", 'controller', LOG_ERR );

    // debug
    // die( var_dump( $a ) );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:
        case METHOD_DELETE:

            // print_r( $befores );
            // print_r( $_REQUEST );
            // $d['id_anagrafica'] = mysqlSelectValue( $c, 'SELECT id_anagrafica FROM mail WHERE id = ?', array( array( 's' => $d['id'] ) ) );
            // var_dump( $d['id'] );
            // var_dump( $d['id_anagrafica'] );
            // die( print_r( mysqlQuery( $c, 'SELECT * FROM anagrafica_view WHERE id = ?', array( array( 's' => $d['id_anagrafica'] ) ) ), true ) );

            #! if( isset( $befores['id_anagrafica'] ) ) {
            #!    mysqlQuery( $c, 'REPLACE INTO anagrafica_view_static SELECT * FROM anagrafica_view WHERE id = ?', array( array( 's' => $befores['id_anagrafica'] ) ) );
            #!    mysqlQuery( $c, 'REPLACE INTO anagrafica_attivi_view_static SELECT * FROM anagrafica_view WHERE id = ?', array( array( 's' => $befores['id_anagrafica'] ) ) );
            #!    mysqlQuery( $c, 'REPLACE INTO anagrafica_archiviati_view_static SELECT * FROM anagrafica_view WHERE id = ?', array( array( 's' => $befores['id_anagrafica'] ) ) );
            #!    logWrite( 'aggiornata view statica ' . $t . '/anagrafica per id #' . $d['id'] . '/' . $befores['id_anagrafica'], 'static' );
            #!}

            logWrite( "controller finally per ${t}/${a}: " . print_r( $befores, true ), 'controller', LOG_ERR );

            if( isset( $befores['id_anagrafica'] ) ) {
                // $_SESSION['static']['anagrafica_view'][ $befores['id_anagrafica'] ] = array( 'field' => 'id' );
                // $_SESSION['static']['anagrafica_attivi_view'][ $befores['id_anagrafica'] ] = array( 'field' => 'id' );
                // $_SESSION['static']['anagrafica_archiviati_view'][ $befores['id_anagrafica'] ] = array( 'field' => 'id' );
                $idAnagrafica = $befores['id_anagrafica'];
                logWrite( "controller finally per ${t}/${a} OK static: " . $idAnagrafica, 'controller', LOG_ERR );
            } elseif( isset( $befores['codice_anagrafica'] ) ) {
                $idAnagrafica = mysqlSelectValue(
                    $c,
                    'SELECT id FROM anagrafica WHERE codice = ?',
                    array( array( 's' => $befores['codice_anagrafica'] ) )
                );
                logWrite( "controller finally per ${t}/${a} OK CODICE static", 'controller', LOG_ERR );
            } elseif( isset( $d['id_anagrafica'] ) && ! empty( $d['id_anagrafica'] ) ) {
                $idAnagrafica = $d['id_anagrafica']; 
                logWrite( "controller finally per ${t}/${a} OK DATI static", 'controller', LOG_ERR );
            } elseif( isset( $vs['id_anagrafica']['s'] ) && ! empty( $vs['id_anagrafica']['s'] ) ) {
                $idAnagrafica = $vs['id_anagrafica']['s'];
                logWrite( "controller finally per ${t}/${a} OK VS static", 'controller', LOG_ERR );
            } else {
                logWrite( "controller finally per ${t}/${a} NO static " . print_r( $befores, true ), 'controller', LOG_ERR );
            }

            if( isset( $idAnagrafica ) && ! empty( $idAnagrafica ) ) {
                // updateAnagraficaViewStaticCategorie( $idAnagrafica );
                updateAnagraficaViewStatic( $idAnagrafica );
                logWrite( "controller finally per ${t}/${a} OK static AGGIORNATO ID: " . $idAnagrafica, 'controller', LOG_ERR );
            }

        break;

	}
