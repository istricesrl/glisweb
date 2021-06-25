<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    $st = array(); 

    // calcolo del numero pratica in base alla sede di aapertura se la pratica non ha un numero
    if( isset( $_REQUEST['nome'] ) && !empty( $_REQUEST['nome'] ) ) {

        if( empty( $_REQUEST['id_marchio'] ) ){ $_REQUEST['id_marchio'] = NULL; }
        if( empty( $_REQUEST['id_produttore'] ) ){ $_REQUEST['id_produttore'] = NULL; }
        if( empty( $_REQUEST['serial'] ) ){ $_REQUEST['serial'] = NULL; }
        if( empty( $_REQUEST['testo'] ) ){ $_REQUEST['testo'] = NULL; }

        $st['numero'] = (int)mysqlQuery( $cf['mysql']['connection'], 'INSERT INTO matricole ( id_marchio, id_produttore, serial_number, nome, testo, timestamp_inserimento, id_account_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ? ) ',
				 array( 
                        array( 's' => $_REQUEST['id_marchio'] ), 
                        array( 's' => $_REQUEST['id_produttore'] ), 
                        array( 's' => $_REQUEST['serial'] ), 
                        array( 's' => $_REQUEST['nome'] ), 
                        array( 's' => $_REQUEST['testo'] ), 
                        array( 's' => time() ),
                        array( 's' =>  ( isset( $_SESSION['account']['id'] ) ? $_SESSION['account']['id'] : NULL ) )
                  ) );
    
        if( $st['numero'] > 0 ){

            $st['status'] = 'OK';

        } else {

            $st['status'] = 'NO';
            $st['error'][] = 'errore inserimento matricola';

        }
    
    } else {

        $st['status'] = 'NO';
        $st['error'][] = 'nessun nome matricola passato';

    }


    buildJson( $st );
