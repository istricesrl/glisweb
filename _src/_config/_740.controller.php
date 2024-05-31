<?php

    /**
     * 
     * 
     * 
     * 
     */

    // trovo le sottocartelle della cartella di importazione
    $programmati = getDirList( DIR_VAR_SPOOL_IMPORT . 'todo/' );

    // ...
    if( ! empty( $programmati ) ) {

        // log
        logWrite( 'cartelle programmate: ' . print_r( $programmati, true ), 'import', LOG_ERR );

        // cerco le cartelle programmate nel passato
        foreach( $programmati as $programmata ) {

            // se la cartella è programmata nel passato
            if( basename( $programmata ) <= date('YmdHis') ) {

                // log
                logWrite( 'cartella da elaborare (su '.date('YmdHis').'): ' . $programmata, 'import', LOG_ERR );

                // ottengo l'elenco dei file nella cartella
                $programmati = getFileList( DIR_VAR_SPOOL_IMPORT . 'todo/' . $programmata . '/' );

                // ...
                if( ! empty( $programmati ) ) {

                    // log
                    logWrite( 'file da elaborare: ' . print_r( $programmati, true ), 'import', LOG_ERR );

                    // sposto i file nella cartella di importazione
                    foreach( $programmati as $programmato ) {

                        // log
                        logWrite( 'file da elaborare: ' . $programmato, 'import', LOG_ERR );

                        // sposto il file nella cartella di importazione
                        moveFile( DIR_VAR_SPOOL_IMPORT . 'todo/' . $programmata . '/' . $programmato, DIR_VAR_SPOOL_IMPORT . $programmato );

                    }

                    // elimino la cartella
                    deleteDir( DIR_VAR_SPOOL_IMPORT . 'todo/' . $programmata . '/' );

                }

            }


        }

    }

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
