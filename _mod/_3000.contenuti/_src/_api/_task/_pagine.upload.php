<?php

    /**
     * 
     * richiede ad es. ?id=1&target=PROD
     * 
     * 
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivata una pagina
    if( ! empty( $_REQUEST['id'] ) && ! empty( $_REQUEST['id'] ) ) {

        // ID della pagina
        $status['id'] = $_REQUEST['id'];

        // verifico se è aspecificato il target
        if( ! empty( $_REQUEST['target'] ) && ! empty( $_REQUEST['target'] ) ) {

            // target della pagina
            $status['target'] = $_REQUEST['target'];

            // server target
            if( isset( $cf['mysql']['profiles'][ $_REQUEST['target'] ]['servers'] ) ) {

                // server
                $server = $cf['mysql']['servers'][ $cf['mysql']['profiles'][ $_REQUEST['target'] ]['servers'][0] ];

                // connessione al database target
                $cTarget = mysqli_connect(
                    $server['address'],
                    $server['username'],
                    $server['password'],
                    $server['db'],
                );

                // verifico la connessione target
                if( ! empty( $cTarget ) ) {

                    // recupero la pagina
                    $source = mysqlSelectRow(
                        $cf['mysql']['connection'],
                        'SELECT * FROM pagine WHERE id = ?',
                        array( array( 's' => $_REQUEST['id'] ) ) 
                    );

                    // controllo se la riga esiste
                    if( ! empty( $source ) ) {

                        // inserisco la pagina
                        $idPagina = mysqlInsertRow(
                            $cTarget,
                            $source,
                            'pagine'
                        );

                        // verifica inserimento pagina
                        if( ! empty( $idPagina ) ) {

                            // status
                            $status['info'][] = 'inserita la pagina ' . $idPagina;

                            // oggetti collegati
                            foreach( array( 'contenuti', 'menu', 'immagini', 'file', 'metadati', 'macro' ) as $entita ) {

                                // recupero le entità da inserire
                                $ents = mysqlQuery(
                                    $cf['mysql']['connection'],
                                    'SELECT * FROM ' . $entita . ' WHERE id_pagina = ?',
                                    array( array( 's' => $_REQUEST['id'] ) ) 
                                );

                                // inserisco le entità
                                foreach( $ents as $ent ) {

                                    // inserimento
                                    mysqlInsertRow(
                                        $cTarget,
                                        $ent,
                                        $entita
                                    );

                                    // copia file
                                    if( in_array( $entita, array( 'immagini', 'file' ) ) ) {

                                        // TODO implementare

                                    }

                                }

                            }

                        } else {

                            // status
                            $status['err'][] = 'impossibile inserire la pagina ' . $_request['id'];

                        }

                    } else {

                        // status
                        $status['err'][] = 'dati non trovati per la pagina ' . $_request['id'];
                        
                    }

                } else {

                    // status
                    $status['err'][] = 'connessione remota non disponibile (' . mysqli_connect_errno() . ' ' . mysqli_connect_error() . ')';

                }

            } else {

                // status
                $status['err'][] = 'server non disponibile';

            }

        } else {

            // status
            $status['err'][] = 'target della pagina non passato';
    
        }

    } else {

        // status
        $status['err'][] = 'ID della pagina non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
