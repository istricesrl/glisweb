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
    // print_r( $csv );

    // elaboro i CSV
    foreach( $csv as $f ) {

        // ricavo l'azione e l'entità
        $req = explode( '.', basename( $f ) );
        $action = $req[0];
        $table = $req[1];

        // debug
        // print_r( readFromFile( $f ) );

        // elaboro i dati
        if( ! isset( $_REQUEST[ $table ] ) ) {

            foreach( csvFile2array( $f, ';' ) as $riga ) {

                // TODO
                // non c'è modo di far confluire questi dati nella controller della request
                // popolando $_REQUEST[ tabella ][ n ]...
                $riga['__method__'] = strtoupper( $action );
    #            $_REQUEST[ $table ]['__method__'] = strtoupper( $action );

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

                $_REQUEST[ $table ][] = $riga;

            }

            // elimino il file importato
            deleteFile( $f );

        }

    }

    // debug
    // print_r( $_REQUEST );
