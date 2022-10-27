<?php

    /**
     * effettua la creazione di un nuovo oggetto controllo all'interno di un audit
     * riceve in ingresso i parametri seguenti:
     * - id_audit: id dell'audit genitore
     * - id_anagrafica: id dell'eventuale anagrafica associata (non obbligatorio)
     * - id_questionario: id del questionario da applicare
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
    if( ! empty( $_REQUEST['id_audit'] ) && ! empty( $_REQUEST['id_questionario'] )  ) {

        $status['id_audit'] = $_REQUEST['id_audit'];
        $status['id_progetto'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id_progetto FROM audit WHERE id = ?',
            array( array( 's' => $status['id_audit'] ) )
        );
        $status['id_questionario'] = $_REQUEST['id_questionario'];

        if( ! empty( $_SESSION['account']['id'] ) ){
            $status['id_account'] = $_SESSION['account']['id'];
        }
        else{
            $status['id_account'] = NULL;
        }

        if( ! empty( $_REQUEST['id_anagrafica'] ) ){
            $status['id_anagrafica'] = $_REQUEST['id_anagrafica'];
        }
        else{
            $status['id_anagrafica'] = NULL;
        }

        $status['controllo'] =  mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO controlli ( id_audit, id_progetto, id_questionario, id_anagrafica, id_account_inserimento, timestamp_inserimento, timestamp_richiesta ) VALUES( ?, ?, ?, ?, ?, ?, ? )',
            array(
                array( 's' => $status['id_audit'] ),
                array( 's' => $status['id_progetto'] ),
                array( 's' => $status['id_questionario'] ),
                array( 's' => $status['id_anagrafica'] ),
                array( 's' => $status['id_account'] ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

    } else {

        // status
        $status['err'][] = 'id_progetto o id_audit o id_questionario non passati';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
