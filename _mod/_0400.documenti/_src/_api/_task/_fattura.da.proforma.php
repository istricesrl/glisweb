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
/*
                            'documenti_articoli' => array(
                                'f' => array(
                                    'id_tipologia' => 1
                                ),
                                'r' => array(
                                    'id_genitore IS NULL'
                                )
                            ),
*/
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

            if( isset( $status['new']['id'] ) && ! empty( $status['new']['id'] ) ) {

                // seleziono le righe del vecchio documento
                $oldRows = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT * FROM documenti_articoli WHERE id_documento = ? AND id_genitore IS NULL',
                    array( array( 's' => $status['current']['id'] ) )
                );

                // duplico le righe del vecchio documento
                foreach( $oldRows as $oldRow ) {

                    // per ogni riga del vecchio documento, duplico le righe aggregate forzando id_documento e id_genitore
                    $newRowId = mysqlDuplicateRow(
                        $cf['mysql']['connection'],
                        'documenti_articoli',
                        $oldRow['id'],
                        NULL,
                        array(
                            'id_tipologia' => 1,
                            'id_documento' => $status['new']['id']
                        )
                    );

                    // seleziono le righe del vecchio documento
                    $oldSubRows = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT * FROM documenti_articoli WHERE id_documento = ? AND id_genitore = ?',
                        array(
                            array( 's' => $status['current']['id'] ),
                            array( 's' => $oldRow['id'] ) 
                        )
                    );

                    // per ogni sub row...
                    foreach( $oldSubRows as $oldSubRow ) {

                        // per ogni riga del vecchio documento, duplico le righe aggregate forzando id_documento e id_genitore
                        $newRowId = mysqlDuplicateRow(
                            $cf['mysql']['connection'],
                            'documenti_articoli',
                            $oldSubRow['id'],
                            NULL,
                            array(
                                'id_tipologia' => 1,
                                'id_genitore' => $newRowId,
                                'id_documento' => $status['new']['id']
                            )
                        );

                    }

                }

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
