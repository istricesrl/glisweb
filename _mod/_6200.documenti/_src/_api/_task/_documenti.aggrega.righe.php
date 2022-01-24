<?php

    /**
     * 
     * @todo documentare
     * 
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    if( isset( $_REQUEST['id'] ) && !empty( $_REQUEST['id'] ) ){

        // seleziono il documento
        $status['current'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM documenti WHERE id = ?',
            array( array( 's' => $_REQUEST['id'] ) )
        );

        if( !empty( $status['current'] ) && !empty( $status['current']['id_tipologia'] ) && !empty( $status['current']['id_destinatario'] ) & !empty( $status['current']['id_emittente'] )  ){

            // recupero tutte le righe della stessa tipologia del documento e dello stesso cliente che non sono legate a documenti
            $status['righe'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM documenti_articoli WHERE id_documento IS NULL AND id_tipologia = ? AND id_destinatario = ? AND id_emittente = ?',
                array(
                    array( 's' => $status['current']['id_tipologia']),
                    array( 's' => $status['current']['id_destinatario']),
                    array( 's' => $status['current']['id_emittente'])
                )
            );

            if( !empty( $status['righe'] ) && count( $status['righe'] ) > 0 ){

                $status['numero'] = 'trovate '.count( $status['righe'] ).' righe da aggregare al documento';
                
                foreach(  $status['righe'] as $r ){

                    mysqlQuery(
                        $cf['mysql']['connection'], 
                        'UPDATE documenti_articoli SET id_documento = ? WHERE id = ?',
                        array( array('s' => $_REQUEST['id'] ), array( 's' => $r['id'] ) )
                    );

                }

            } else {
                $status['error'] = 'non sono presenti righe da aggregare';
            }
            
        } else {
            $status['error'] = 'dati documento assenti';
        }
        
        

    } else {

        $status['error'] = 'id documento assente';

    }



    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
