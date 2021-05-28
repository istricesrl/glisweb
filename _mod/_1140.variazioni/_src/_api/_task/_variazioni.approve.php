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

            // estraggo gli id delle attivita e dei progetti che rimangono scoperti
            $scoperture = mysqlQuery(
                $cf['mysql']['connection'],
                "SELECT id, id_progetto, data_programmazione FROM attivita_view "
                ."WHERE id_anagrafica = ? "
                ."AND ( ( TIMESTAMP( data_programmazione, ora_inizio_programmazione ) between ? and ? ) "
                ."OR ( TIMESTAMP( data_programmazione, ora_fine_programmazione ) between ? and ? ) )",
                array(
                    array( 's' =>  $v['id_anagrafica'] ),
                    array( 's' =>  $data_ora_inizio ),
                    array( 's' =>  $data_ora_fine ),
                    array( 's' =>  $data_ora_inizio ),
                    array( 's' =>  $data_ora_fine )
                )
            );


            if( !empty( $scoperture) ){
                
                foreach( $scoperture as $s ){
                    
                    // creo una riga nella tabella __report_attivita_assenze__
                    $raa = mysqlQuery(
                        $cf['mysql']['connection'],
                        "INSERT IGNORE INTO __report_attivita_assenze__ ( id_attivita, id_anagrafica, data_assenza ) VALUES ( ?, ?, ? )",
                        array(
                            array( 's' => $s['id'] ),
                            array( 's' => $v['id_anagrafica'] ),
                            array( 's' => $s['data_programmazione'] )
                        )
                    );

                    $status['info'][] = 'inserite ' . $raa . ' righe dalla tabella __report_attivita_assenze__';

                    // creo una riga nella tabella __report_progetti_assenze__
                /*    $rpa = mysqlQuery(
                        $cf['mysql']['connection'],
                        "INSERT IGNORE INTO __report_progetti_assenze__ ( id_progetto, id_anagrafica, data_assenza ) VALUES ( ?, ?, ? )",
                        array(
                            array( 's' => $s['id_progetto'] ),
                            array( 's' => $v['id_anagrafica'] ),
                            array( 's' => $s['data_programmazione'] )
                        )
                    );

                    $status['info'][] = 'inserite ' . $raa . ' righe dalla tabella __report_progetti_assenze__';
                */
                }
            }
           
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

        // setto la data di approvazione della variazione alla data corrente
        $approva = mysqlQuery(
            $cf['mysql']['connection'],
            "UPDATE variazioni_attivita SET data_approvazione = ? WHERE id = ?",
            array(
                array( 's' => date('Y-m-d') ),
                array( 's' => $_REQUEST['id'])
            )
        );

        $status['info'][] = 'variazione ' . $_REQUEST['id'] . ' approvata con data ' . date('Y-m-d');


         // passo successivo: per ogni giorno di ogni riga periodi
            // 1- prendo la data
            // 2- vado a vedere se c'è un turno attivo per quella data e quell'anagrafica
            // 3- vado nel contratto attivo per l'anagrafica corrente e vedo per quel turno che orari sono previsti
            // 4- creo una riga di attività con la tipologia inps indicata per ogni fascia di orari_contratti trovata
            // 5- vedo se ci sono attività già pianificate per quella fascia di data e ora e setto id_anagrafica NULL
        
        // funzione utile:
        /*
            - funzione che partendo da data_inizio e data_fine restituisce l'elenco delle date comprese       
        */


    } else {

        // status
        $status['err'][] = 'ID variazione non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}