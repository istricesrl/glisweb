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

    //die( print_r( $_REQUEST ) );

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

            if( isset( $_REQUEST['id_riga'] ) ){

                $update = mysqlQuery( $cf['mysql']['connection'], 'UPDATE documenti_articoli SET matricola = ? WHERE id = ? ',
                                    array( array( 's' => $st['numero'] ), array( 's' => $_REQUEST['id_riga'] ) ) );
            

                if( $update ){
                    $st['status'] = 'OK';
                } else {
                    $st['status'] = 'NO';
                    $st['error'][] = 'errore aggiornamento riga documento';
                }
            }

        } else {

            $st['status'] = 'NO';
            $st['error'][] = 'errore inserimento matricola';

        }
    
    } elseif( isset( $_REQUEST['barcode'] ) && !empty( $_REQUEST['barcode'] ) && explode( '.', $_REQUEST['barcode'] )[0] == 'MAT'  ){

        $id_matricola = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM matricole WHERE id = ? ',
        array( array( 's' =>  ltrim(explode( '.', $_REQUEST['barcode'] )[1], "0") ) ) );
    
        if( $id_matricola && isset( $_REQUEST['id_riga'] ) ){

            $update = mysqlQuery( $cf['mysql']['connection'], 'UPDATE documenti_articoli SET matricola = ? WHERE id = ? ',
                                array( array( 's' => $id_matricola ), array( 's' => $_REQUEST['id_riga'] ) ) );
        

            if( $update ){

                $st['status'] = 'OK';

            } else {

                $st['status'] = 'NO';
                $st['error'][] = 'errore aggiornamento riga documento';

            }
            
        } else {
         
            $st['status'] = 'NO';
            $st['error'][] = 'nessun matricola corrispondente a barcode';

        }

    } else {

        $st['status'] = 'NO';
        $st['error'][] = 'nessun dato per generazione matricola matricola passato';

    }


    buildJson( $st );
