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

    // elaboro i CSV
    foreach( $csv as $f ) {

        // ricavo l'azione e l'entità
        $req = explode( '.', basename( $f ) );
        $action = $req[0];
        $table = $req[1];

        // debug
        // print_r( readFromFile( $f ) );
        // die();

        // elaboro i dati
        if( ! isset( $_REQUEST[ $table ] ) ) {

            foreach( csvFile2array( $f, NULL ) as $riga ) {

                // TODO
                // non c'è modo di far confluire questi dati nella controller della request
                // popolando $_REQUEST[ tabella ][ n ]...
                $riga['__method__'] = strtoupper( $action );
                // $_REQUEST[ $table ]['__method__'] = strtoupper( $action );
#                $_REQUEST['__info__'][ $k ]

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

/* NOTA aggiungendo ID = NULL a una query UPDATE si riceve un errore di vincolo di chiave su ID (perché la controller cerca
giustamente di settare ID = NULL sulla riga che innesca l'eventuale constraint, ad esempio sul codice)

PERCHÈ era stato inserito questo if? forse perché senza non funziona la INSERT o la REPLACE? testare su Eurosnodi

                // ...
                if( ! isset( $riga['id'] ) ) {
                    $riga['id'] = NULL;
                }
*/

                // firma per l'autorizzazione della riga
                if( isset( $cf['auth']['import']['secret'] ) ) {

                    // debug
                    // print_r( $riga );

                    // creazione firma
                    $riga['__firma__'] = hash( getAvailableHashMethod(), serialize( $riga ) . $cf['auth']['import']['secret'] );

                    // debug
                    // var_dump( $riga['__firma__'] );
                    // print_r(hash_algos());

                    // ...
                    $_REQUEST[ $table ][] = $riga;

                } else {

                    // debug
                    // die( 'secret non impostato' );

                }

                // debug
                // print_r( $riga );

            }

        }

        // elimino il file importato
        // deleteFile( $f );

        // archivio il file importato
        moveFile( $f, DIR_VAR_SPOOL_IMPORT_DONE . date( 'YmdHis' ) . '/' );

        // debug
        // die( 'sposto' . $f . ' in ' . DIR_VAR_SPOOL_IMPORT_DONE );

    }

    // debug
    // print_r( $_REQUEST );
