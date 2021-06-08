<?php

    /**
     * task richiamato per rimuovere un operatore dalle attività di un progetto pianificate in un dato periodo e in una specifica fascia oraria
     * riceve in ingresso i parametri seguenti:
     * - id_progetto: id del progetto
     * - id_anagrafica: id dell'operatore
     * - data_inizio: data di inizio del periodo
     * - data_fine: data di fine del periodo
     * - ora_inizio (facoltativa): ora di inizio
     * - ora_fine (facoltativa): ora di fine
     * 
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
    if( ! empty( $_REQUEST['id_progetto'] ) && ! empty( $_REQUEST['id_anagrafica'] ) && ! empty( $_REQUEST['data_inizio'] ) && ! empty( $_REQUEST['data_fine'] ) ) {

        // ID del progetto
        $status['id_progetto'] = $_REQUEST['id_progetto'];

        // ID dell'operatore
        $status['id_anagrafica'] = $_REQUEST['id_anagrafica'];

        // data inizio
        $status['data_inizio'] = $_REQUEST['data_inizio'];

        // data fine
        $status['data_fine'] = $_REQUEST['data_fine'];

        $where = array();
        $params = array();

        $where[] = 'coalesce( a.id_progetto, t.id_progetto ) = ?';
        $params[] = array( 's' => $_REQUEST['id_progetto'] );

        $where[] = 'a.id_anagrafica = ?';
        $params[] = array( 's' => $_REQUEST['id_anagrafica'] );

        $where[] = '( coalesce( a.data_programmazione, t.data_programmazione ) BETWEEN ? AND ? )';
        $params[] = array( 's' => $_REQUEST['data_inizio'] );
        $params[] = array( 's' => $_REQUEST['data_fine'] );

        if( ! empty( $_REQUEST['ora_inizio'] ) && ! empty( $_REQUEST['ora_fine'] ) ){

             // ora inizio
            $status['ora_inizio'] = $_REQUEST['ora_inizio'];

            // data fine
            $status['ora_fine'] = $_REQUEST['ora_fine'];

            $where[] = 'coalesce( a.ora_inizio_programmazione, t.ora_inizio_programmazione )  >= ?';
            $params[] = array( 's' => $_REQUEST['ora_inizio'] );

            $where[] = 'coalesce( a.ora_fine_programmazione, t.ora_fine_programmazione ) <= ? ';
            $params[] = array( 's' => $_REQUEST['ora_fine'] );
            
        }

        $q = 'UPDATE attivita as a LEFT JOIN todo as t ON a.id_todo = t.id SET a.id_anagrafica = NULL WHERE ('  . implode( ' AND ', $where ) . ')';

        $r = mysqlQuery(
            $cf['mysql']['connection'],
            $q,
            $params
        );

        $status['info'][] = 'aggiornate ' . $r . ' righe di attivita';
       
    } else {

        // status
        $status['err'][] = 'parametri in input richiesti non passati';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
