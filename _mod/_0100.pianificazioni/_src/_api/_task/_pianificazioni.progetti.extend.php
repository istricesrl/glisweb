<?php

    /**
     * task che riceve in ingresso un ID progetto, cerca le pianificazioni attive ad esso relative e le allunga
     * richiamando il task _pianificazioni.extend.php
     * 
     *
     *
     *
     * @todo commentare
     * @todo usare le funzioni di ACL per verificare se l'azione è autorizzata
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // se è specificato un ID progetto
    if( isset( $_REQUEST['id'] ) ) {

        $status['pianificazioni'] = mysqlSelectColumn(
            'id',
            $cf['mysql']['connection'],
            'SELECT pianificazioni.id FROM pianificazioni '
            .'INNER JOIN todo ON pianificazioni.id_todo = todo.id '
            .'WHERE todo.id_progetto = ? AND pianificazioni.giorni_rinnovo > 0',
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );

        if( !empty( $status['pianificazioni'] ) ){
            foreach( $status['pianificazioni'] as $p ){

                $url = $cf['site']['url'] . '_mod/_0750.pianificazioni/_src/_api/_task/_pianificazioni.extend.php?id=' . $p;
                
                if(! empty( $_REQUEST['hard'] ) ){
                    $url .= '&hard=' . $_REQUEST['hard'];
                }
                if(! empty( $_REQUEST['data_fine'] ) ){
                    $url .= '&data_fine=' . $_REQUEST['data_fine'];
                }
                
                $status['pianificazioni'][$p] = restcall(
                    $url
                );
                
            }
        }

    } else {

        // status
        $status['info'][] = 'nessun progetto passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
