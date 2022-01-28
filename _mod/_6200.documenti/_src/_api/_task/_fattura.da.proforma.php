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

    // se è passato un ID documento
    if( isset( $_REQUEST['id'] ) ) {

        // seleziono il documento da duplicare
        // TODO basarsi sui flag delle tipologie e non sull'id_tipologia
        $status['current'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM documenti WHERE id = ? AND id_tipologia = 5',
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );

        // verifico che il documento richiesto sia valido
        if( ! empty( $status['current']['id'] ) ) {

            // status
            $status['info'][] = 'procedo con la duplicazione';
            $status['new'] = array();

            // array per il nuovo oggetto
            $status['model'] = array(
                't' => array(
                    'documenti' => array(
                        't' => array(
                            'documenti_articoli' => array(
                                't' => array(
                                    'documenti_articoli' => array(
                                        'f' => array(
                                            'id_tipologia' => 1
                                        )
                                    )
                                ),
                                'f' => array(
                                    'id_tipologia' => 1
                                )
                            ),
                            'pagamenti' => array()
                        ),
                        'f' => array(
                            'id_tipologia' => 1
                        )
                    )
                )
            );

            // duplicazione del documento

            mysqlDuplicateRowRecursive(
                $cf['mysql']['connection'],
                'documenti',
                $status['current']['id'],
                NULL,
                $status['model'],
                $status['new']
            );


            if( isset($status['new']) && !empty($status['new']) ){
                
                mysqlQuery( 
                    $cf['mysql']['connection'], 
                    'INSERT INTO relazioni_documenti (id_documento, id_documento_collegato) VALUES ( ?, ? )',
                    array( array( 's' => $status['current']['id'] ), array( 's' => $status['new']['id'] ) )
                );

            }
            

            // aggiornamento vista statica
            // mysqlQuery( $c, 'CALL anagrafica_view_static( ? )', array( array( 's' => $d['id'] ) ) );

        } else {

            // status
            $status['err'][] = 'documento non trovato o impossibile da convertire';
            
        }

    } else {

        // status
        $status['err'][] = 'ID documento non passato';

    }

    // debug
    // print_r( $status );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
