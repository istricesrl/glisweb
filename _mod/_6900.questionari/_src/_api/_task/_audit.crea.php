<?php

    /**
     * effettua la creazione di un nuovo oggetto audit
     * riceve in ingresso i parametri seguenti:
     * - id_progetto: id del progetto
     * - data: data dell'audit
     *
     * 
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // verifico se sono arrivati i parametri richiesti
    if( ! empty( $_REQUEST['id_progetto'] ) && ! empty( $_REQUEST['data'] ) ) {

        $progetto = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM progetti WHERE id = ?',
            array( array( 's' => $_REQUEST['id_progetto'] ) )
        );

        $status['id_progetto'] = $_REQUEST['id_progetto'];
        $status['data'] = $_REQUEST['data'];

        if( ! empty( $_SESSION['account']['id'] ) && ! empty( $_SESSION['account']['id_anagrafica'] ) ){
            $status['id_account'] = $_SESSION['account']['id'];
            $status['id_anagrafica'] = $_SESSION['account']['id_anagrafica'];

            $status['audit'] =  mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT INTO audit (id_progetto, id_somministratore, id_account_inserimento, timestamp_inserimento, data_audit, nome) VALUES( ?, ?, ?, ?, ?, ? )',
                array(
                    array( 's' => $status['id_progetto'] ),
                    array( 's' => $status['id_anagrafica'] ),
                    array( 's' => $status['id_account'] ),
                    array( 's' => time() ),
                    array( 's' => $status['data'] ),
                    array( 's' => 'audit su cantiere ' . $progetto['nome'] . ' del ' . $status['data'] )
                )
            );
        }

    } else {

        // status
        $status['err'][] = 'id_progetto o data non passati';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
