<?php

    /**
     * 
     * richiede ad es. ?id=1&target=PROD
     * 
     * 
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivata una template
    if( ! empty( $_REQUEST['id'] ) && ! empty( $_REQUEST['id'] ) ) {

        // ID del template
        $status['id'] = $_REQUEST['id'];

        // verifico se è aspecificato il target
        if( ! empty( $_REQUEST['target'] ) && ! empty( $_REQUEST['target'] ) ) {

            // target del template
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

                    // recupero il template
                    $source = mysqlSelectRow(
                        $cf['mysql']['connection'],
                        'SELECT * FROM template WHERE id = ?',
                        array( array( 's' => $_REQUEST['id'] ) ) 
                    );

                    // controllo se la riga esiste
                    if( ! empty( $source ) ) {

                        // inserisco il template
                        $idTemplate = mysqlInsertRow(
                            $cTarget,
                            $source,
                            'template'
                        );

                        // verifica inserimento template
                        if( ! empty( $idTemplate ) ) {

                            // status
                            $status['info'][] = 'inserita il template ' . $idTemplate;

                            // oggetti collegati
                            foreach( array( 'contenuti', 'file' ) as $entita ) {

                                // recupero le entità da inserire
                                $ents = mysqlQuery(
                                    $cf['mysql']['connection'],
                                    'SELECT * FROM ' . $entita . ' WHERE id_template = ?',
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
                                    if( in_array( $entita, array( 'file' ) ) ) {

                                        // TODO implementare

                                    }

                                }

                            }

                        } else {

                            // status
                            $status['err'][] = 'impossibile inserire il template ' . $_request['id'];

                        }

                    } else {

                        // status
                        $status['err'][] = 'dati non trovati per il template ' . $_request['id'];
                        
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
            $status['err'][] = 'target del template non passato';
    
        }

    } else {

        // status
        $status['err'][] = 'ID del template non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
