<?php

    /**
     * gestione inserimento dati dati
     * 
     * 
     * 
     */

    // debug
    // print_r( $cf['debug'] );
    // error_reporting( E_ALL );
    // ini_set( 'display_errors', TRUE );
    // echo 'OUTPUT';

    // ...
    if( defined( 'CRON_RUNNING' ) ) {

        /**
         * GESTIONE BLOCCHI DATI PROGRAMMATI
         * =================================
         * 
         * 
         */

        // ...

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

        /**
         * GESTIONE BLOCCHI DATI
         * =====================
         * 
         * 
         */

        // ...

        // cerco file CSV da importare
        $csv = glob( DIR_VAR_SPOOL_IMPORT . '*.csv' );

        // debug
        // die( 'ricerca file di importazione' );
        // print_r( $csv );
        // die();

        // ordinamento
        sort( $csv );

        // elaboro i CSV
        foreach( $csv as $f ) {

            // ...
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

    /**
     * CONTROLLER IMMAGINI
     * ===================
     * 
     * 
     */

    // trovo le immagini presenti in var/spool/import/
    $img = glob( DIR_VAR_SPOOL_IMPORT . '*.{jpg,png,jpeg}', GLOB_BRACE );

    // debug
    // die( print_r( $img, true ) );

    // se c'è almeno un'immagine da elaborare
    if( ! empty( $img ) ) {

        // prelevo un'immagine dalla lista
        $f = array_shift( $img );

        // debug
        // die( print_r( $img, true ) );

        // ricavo l'azione e l'entità
        $req = explode( '§', basename( $f ) );

        // gestione del formato [NN§]azione§entita§codice§ruolo[§ordine][§varie].{jpg,png,jpeg}
        if( is_numeric( $req[0] ) ) {
            $action = $req[1];
            $table = $req[2];
            $codice = $req[3];
            $ruolo = $req[4];
            $ordine = ( isset( $req[5] ) ) ? $req[5] : NULL;
        } else {
            $action = $req[0];
            $table = $req[1];
            $codice = $req[2];
            $ruolo = $req[3];
            $ordine = ( isset( $req[4] ) ) ? $req[4] : NULL;
        }

        // ...
        if( ! is_numeric( $ordine ) ) {
            $ordine = NULL;
        }

        // debug
        // die( print_r( $req, true ) );

        // gestione del ruolo passato come ID numerico
        if( ! is_numeric( $ruolo ) ) {
            $ruolo = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT id FROM ruoli_immagini WHERE nome = ?',
                array( array( 's' => $ruolo ) )
            );
        }

        // dati per l'inserimento
        switch( $table ) {
            case 'prodotti':
                $field = 'id_prodotto';
            break;
            case 'articoli':
                $field = 'id_articolo';
            break;
        }

        // collante
        foreach( array( '§', '-' ) as $g ) {
            if( strpos( $codice, $g ) === false ) {
                $gl = $g;
            }
        }

        // percorso di destinazione
        $dst = DIR_VAR_IMMAGINI . implode( $gl, arrayTrim( array( $table, $codice, $ruolo, $ordine ) ) ) . '.' . strtolower( getFileExtension( $f ) );

        // debug
        // die( $dst );
        // die( $ruolo );

        // preparo l'oggetto
        $riga = array(
            'id_ruolo' => $ruolo,
            'path' => $dst,
            'timestamp_inserimento' => time()
        );

        $riga[ $field ] = $codice;

        // debug
        // die( print_r( $riga, true ) );

        // inserisco la riga nella tabella immagini
        $idImmagine = mysqlInsertRow(
            $cf['mysql']['connection'],
            $riga,
            'immagini'
        );

        // debug
        // die( $idImmagine );

        // se l'immagine è stata inserita
        if( ! empty( $idImmagine ) ) {

            // sposto il file
            moveFile( $f, $dst );

            // se il file è stato spostato
            if( file_exists( $dst ) ) {

                // log
                logger( 'importato file ' . $f . ' su ' . $dst, 'immagini' );

            } else {

                // log
                logger( 'impossibile importare il file ' . $f . ' su ' . $dst, 'immagini' );

                // pulizia databare
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'DELETE FROM immagini WHERE id = ?',
                    array( array( 's' => $idImmagine ) )
                );

            }

        }

    }

    /**
     * DEBUG
     * =====
     * 
     * 
     */

    // debug
    // print_r( $_REQUEST );
    // if( isset( $cf['ws']['table'] ) ) {
        // die( print_r( $_REQUEST[ $cf['ws']['table'] ], true ) );
    // }
    // die();
