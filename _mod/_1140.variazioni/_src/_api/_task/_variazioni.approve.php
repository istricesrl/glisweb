<?php

    /**
     * riceve in ingresso l'id della variazione da approvare
     * prende tutte le attività legate a quella richiesta di variazione e setta id_anagrafica a NULL
     * per ogni giorno del periodo di variazione crea le attività previste da contratto settandole alla tipologia_inps indicata nella variazione
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
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID della variazione in oggetto
        $status['id'] = $_REQUEST['id'];

        // leggo i dati completi della variazione corrente
        $v = mysqlSelectRow( 
            $cf['mysql']['connection'], 
            "SELECT * FROM variazioni_attivita WHERE id = ?",
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );

        // leggo i periodi associati alla variazione corrente
        $periodi = mysqlQuery(
            $cf['mysql']['connection'],
            "SELECT * FROM periodi_variazioni_attivita WHERE id_variazione = ?",
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );

        foreach( $periodi as $p ){
    // se l'ora inizio non è settata parto dalla mezzanotte, idem per l'ora fine
            if( empty( $p['ora_inizio'] ) ){
                $p['ora_inizio'] = '00:00:01';
            }
            if( empty( $p['ora_fine'] ) ){
                $p['ora_fine'] = '23:59:59';
            }
            
            $data_ora_inizio = $p['data_inizio'] . " " . $p['ora_inizio'];
            $data_ora_fine = $p['data_fine'] . " " . $p['ora_fine'];

            $u = 0;
            // aggiorno le attività coinvolte settando id_anagrafica NULL
            $u = mysqlQuery( 
                $cf['mysql']['connection'],
                "UPDATE attivita LEFT JOIN todo ON todo.id = attivita.id_todo SET attivita.id_anagrafica = NULL "
                ."WHERE attivita.id_anagrafica = ? "
                ."AND ( ( coalesce( TIMESTAMP( attivita.data_programmazione, attivita.ora_inizio_programmazione ), TIMESTAMP( todo.data_programmazione, todo.ora_inizio_programmazione ) ) between ? and ? ) "
                ."OR ( coalesce( TIMESTAMP( attivita.data_programmazione, attivita.ora_fine_programmazione ), TIMESTAMP( todo.data_programmazione, todo.ora_fine_programmazione ) ) between ? and ? ) )"
            ,
                array(
                    array( 's' =>  $v['id_anagrafica'] ),
                    array( 's' =>  $data_ora_inizio ),
                    array( 's' =>  $data_ora_fine ),
                    array( 's' =>  $data_ora_inizio ),
                    array( 's' =>  $data_ora_fine )
                )
            );
    
            // status
            $status['info'][] = 'aggiornate ' . $u . ' righe dalla tabella attivita per il periodo ' . $p['data_inizio'] . ' ' . $p['ora_inizio'] . ' - ' . $p['data_fine'] . ' ' . $p['ora_fine'];
        }
        


    } else {

        // status
        $status['err'][] = 'ID variazione non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
