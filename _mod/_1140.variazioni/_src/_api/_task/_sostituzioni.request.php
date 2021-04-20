<?php

    /**
     * riceve in ingresso id_attivita e id_anagrafica
     * crea una riga nella tabella sostituzioni che propone l'anagrafica ricevuta come sostituto per l'attivita ricevuta
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

    // verifico se è arrivata una variazione
    if( ! empty( $_REQUEST['id_attivita'] ) && ! empty( $_REQUEST['id_anagrafica'] ) ) {

        // ID dell'attività
        $status['id_attivita'] = $_REQUEST['id_attivita'];

        // ID dell'anagrafica candidata
        $status['id_anagrafica'] = $_REQUEST['id_anagrafica'];

        // inserisco la riga di sostituzione
        $q = mysqlQuery(
            $cf['mysql']['connection'],
            "INSERT INTO sostituzioni_attivita ( id_attivita, id_anagrafica, data_richiesta ) VALUES ( ?, ?, ? )",
            array(
                array( 's' => $_REQUEST['id_attivita'] ),
                array( 's' => $_REQUEST['id_anagrafica'] ),
                array( 's' => date('Y-m-d') )
            )
        );

        $status['info'][] = 'inserita riga di sostituzione di id ' . $q . ' e con data ' . date('Y-m-d');

        // se la riga di sostituzione è stata inserita e sono in modalità hard procedo con la conferma e l'aggiornamento dell'attività
        if( !empty( $q ) && !empty( $_REQUEST['hard'] ) ){
            $status['sostituzione'] = $q;
            $status['hard'] = $_REQUEST['hard'];
            $status['attivita'] = restcall(
                $cf['site']['url'] . '_mod/_1140.variazioni/_src/_api/_task/_sostituzioni.confirm.php?id=' . $q
            );
        }


    } else {

        // status
        $status['err'][] = 'anagrafica o attività non ricevute';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
