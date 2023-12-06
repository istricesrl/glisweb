<?php

    /**
     * 
     * 
     * 
     * 
     */

    // cerco file CSV da importare
    $csv = glob( DIR_VAR_SPOOL_IMPORT . '*.csv' );

    // debug
    // die( 'ricerca file di importazione' );
    // print_r( $csv );
    // die();

    // ordinamento
    sort( $csv );

    // ...
    if( defined( 'CRON_RUNNING' ) ) {

        // elaboro i CSV
        foreach( $csv as $f ) {
            // $f = array_shift( $csv );

            // ...
            // if( file_exists( $f ) ) {
        
            // ...
            logWrite( 'importo: ' . $f, 'import', LOG_ERR );

            // ...
            // if( filemtime( $f ) < strtotime( '-1 minutes' ) ) {
            // if( true ) {

            // ricavo l'azione e l'entità
            $req = explode( '.', basename( $f ) );

            // gestione del formato [NN.]azione.entita.[varie.]csv
            if( is_numeric( $req[0] ) ) {
                $action = $req[1];
                $table = $req[2];
            } else {
                $action = $req[0];
                $table = $req[1];
            }

            // debug
            // print_r( readFromFile( $f ) );
            // die();

            // elaboro i dati
            if( ! isset( $_REQUEST[ $table ] ) ) {

                // ...
                $fd = DIR_VAR_SPOOL_IMPORT_DONE . date( 'YmdHis' ) . '/' . basename( $f );

                // archivio il file importato
                moveFile( $f, DIR_VAR_SPOOL_IMPORT_DONE . date( 'YmdHis' ) . '/' );

                foreach( csvFile2array( $fd, NULL ) as $riga ) {

                    // TODO
                    // non c'è modo di far confluire questi dati nella controller della request
                    // popolando $_REQUEST[ tabella ][ n ]...
                    $riga['__method__'] = strtoupper( $action );
                    // $_REQUEST[ $table ]['__method__'] = strtoupper( $action );
                    // $_REQUEST['__info__'][ $k ]

                    // debug
                    // print_r( $riga );

                    /*
                    // attivazione controller
                    controller(
                        $cf['mysql']['connection'],				// connessione al database
                        $cf['memcache']['connection'],			// connessione a memcache
                        $riga,							// blocco dati di lavoro
                        $table,							// nome dell'entità su cui lavorare
                        strtoupper( $action ),				// metodo da applicare
                        NULL						// campo per la ricorsione
                    );
                    */

                    // ...
                    if( ! isset( $riga['id'] ) ) {
                        $riga['id'] = NULL;
                    }

                    // firma per l'autorizzazione della riga
                    if( isset( $cf['auth']['import']['secret'] ) ) {

                        // debug
                        // print_r( $riga );

                        // creazione firma
                        $riga['__firma__'] = hash(
                            getAvailableHashMethod(),
                            // serialize( $row ) . $cf['auth']['import']['secret']
                            $table . $cf['auth']['import']['secret']
                        );

                        // debug
                        // var_dump( $riga['__firma__'] );

                        // ...
                        $_REQUEST[ $table ][] = $riga;

                    }

                    // debug
                    // print_r( $riga );

                }

            } else {

                logWrite( 'collisione di tabelle: ' . $table, 'import', LOG_ERR );

            }

            // elimino il file importato
            // deleteFile( $f );

            // archivio il file importato
            // moveFile( $f, DIR_VAR_SPOOL_IMPORT_DONE . date( 'YmdHis' ) . '/' );

            // debug
            // die( 'sposto' . $f . ' in ' . DIR_VAR_SPOOL_IMPORT_DONE );

        }

    }

    // debug
    // print_r( $_REQUEST );
