<?php

    /**
     * task richiamato per scartare un operatore come possibile sostituto per un'attività
     * riceve in ingresso i parametri seguenti:
     * - id_anagrafica: id dell'operatore
     * - id_attivita: id dell'attività
     * 
     * crea una riga nella tabella sostituzioni_attivita per l'anagrafica e l'attività corrente settando data_scarto
     * setta a 0 il punteggio di quell'anagrafica nella tabella __report_sostituzioni_attivita__ in modo che non venga riproposta
     * 
     *
     *
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

    // verifico se è arrivata una sostituzione
    if( ! empty( $_REQUEST['id_anagrafica'] ) && ! empty( $_REQUEST['id_attivita'] ) ) {

        // ID dell'operatore
        $status['id_anagrafica'] = $_REQUEST['id_anagrafica'];

        // ID dell'attività
        $status['id_attivita'] = $_REQUEST['id_attivita'];

        $r = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT IGNORE INTO sostituzioni_attivita ( id_attivita, id_anagrafica, data_scarto ) VALUES (?, ?, ?)',
            array(
                array( 's' => $_REQUEST['id_attivita'] ),
                array( 's' => $_REQUEST['id_anagrafica'] ),
                array( 's' => date('Y-m-d') )
            )
        );

        // setto a 0 il punteggio nella tabella __report_sostituzioni_attivita__ così non me la propone più
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE __report_sostituzioni_attivita__ SET punteggio = 0 WHERE id_attivita = ? AND id_anagrafica = ?',
            array(
                array( 's' => $_REQUEST['id_attivita'] ),
                array( 's' => $_REQUEST['id_anagrafica'] )
            )
        );

        $status['info'][] = 'inserita ' . $r . 'riga di sostituzioni_attivita';
       
    } else {

        // status
        $status['err'][] = 'attività o anagrafica non passati';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
