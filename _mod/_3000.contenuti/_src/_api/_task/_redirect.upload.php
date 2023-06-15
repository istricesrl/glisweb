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

    // verifico se è arrivata un redirect
    if( ! empty( $_REQUEST['id'] ) && ! empty( $_REQUEST['id'] ) ) {

        // ID del redirect
        $status['id'] = $_REQUEST['id'];

        // verifico se è aspecificato il target
        if( ! empty( $_REQUEST['target'] ) && ! empty( $_REQUEST['target'] ) ) {

            // target del redirect
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

                    // recupero il redirect
                    $source = mysqlSelectRow(
                        $cf['mysql']['connection'],
                        'SELECT * FROM redirect WHERE id = ?',
                        array( array( 's' => $_REQUEST['id'] ) ) 
                    );

                    // controllo se la riga esiste
                    if( ! empty( $source ) ) {

                        // inserisco il redirect
                        $idRedirect = mysqlInsertRow(
                            $cTarget,
                            $source,
                            'redirect'
                        );

                        // verifica inserimento redirect
                        if( ! empty( $idRedirect ) ) {

                            // status
                            $status['info'][] = 'inserito il redirect ' . $idRedirect;

                        } else {

                            // status
                            $status['err'][] = 'impossibile inserire il redirect ' . $_request['id'];

                        }

                    } else {

                        // status
                        $status['err'][] = 'dati non trovati per il redirect ' . $_request['id'];
                        
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
            $status['err'][] = 'target del redirect non passato';
    
        }

    } else {

        // status
        $status['err'][] = 'ID del redirect non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
