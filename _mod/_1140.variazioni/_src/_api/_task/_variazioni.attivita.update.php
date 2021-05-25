<?php

    /**
     * task che può:
     * - girare autonomamente > preleva le righe di periodi_variazioni_attivita per le variazioni approvate
     * - essere richiamato dal task _variazioni.attivita.approve.php > riceve in ingresso un id variazione
     * 
     * verifica se ci sono attività in quel periodo assegnate all'utente e:
     * - setta id_anagrafica NULL
     * - crea una riga nella tabella di report __report_attivita_assenze__
     * - setta il timestamp_controllo_attivita
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

     // inizializzo l'array del risultato
	$status = array();

    if( ! empty( $_REQUEST['id'] ) ) {
        $p = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT pv.*, v.id_anagrafica, v.id_tipologia_inps FROM periodi_variazioni_attivita as pv '
            .'LEFT JOIN variazioni_attivita AS v ON pv.id_variazione = v.id '
            .'WHERE pv.id = ?',
            array( array( 's' => $_REQUEST['id'] ) )
        );
    }
    else{
        $p = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT pv.*, v.id_anagrafica, v.id_tipologia_inps FROM periodi_variazioni_attivita as pv '
            .'LEFT JOIN variazioni_attivita AS v ON pv.id_variazione = v.id '
            .'WHERE v.data_approvazione IS NOT NULL '
            .'ORDER BY pv.timestamp_controllo_attivita LIMIT 1'
        );
    }

    // se ho una riga da elaborare
    if( !empty( $p ) ){

        $status['id_periodo'] = $p['id'];

        // se l'ora inizio non è settata parto dalla mezzanotte, idem per l'ora fine
        if( empty( $p['ora_inizio'] ) ){
            $p['ora_inizio'] = '00:00:01';
        }
        if( empty( $p['ora_fine'] ) ){
            $p['ora_fine'] = '23:59:59';
        }
        
        $data_ora_inizio = $p['data_inizio'] . " " . $p['ora_inizio'];
        $data_ora_fine = $p['data_fine'] . " " . $p['ora_fine'];

        // estraggo gli id delle attivita che rimangono scoperte
        $scoperture = mysqlQuery(
            $cf['mysql']['connection'],
            "SELECT id, id_progetto, data_programmazione FROM attivita "
            ."WHERE id_anagrafica = ? "
            ."AND ( ( TIMESTAMP( data_programmazione, ora_inizio_programmazione ) between ? and ? ) "
            ."OR ( TIMESTAMP( data_programmazione, ora_fine_programmazione ) between ? and ? ) )",
            array(
                array( 's' =>  $p['id_anagrafica'] ),
                array( 's' =>  $data_ora_inizio ),
                array( 's' =>  $data_ora_fine ),
                array( 's' =>  $data_ora_inizio ),
                array( 's' =>  $data_ora_fine )
            )
        );

        $status['info']['righe_aggiornate'] = 0;

        if( !empty( $scoperture) ){
            
            foreach( $scoperture as $s ){

                $status['info']['attivita_da_scoprire'][] = $s['id'];
                
                // creo una riga nella tabella __report_attivita_assenze__
                $raa = mysqlQuery(
                    $cf['mysql']['connection'],
                    "INSERT IGNORE INTO __report_attivita_assenze__ ( id_attivita, id_anagrafica, data_assenza ) VALUES ( ?, ?, ? )",
                    array(
                        array( 's' => $s['id'] ),
                        array( 's' => $p['id_anagrafica'] ),
                        array( 's' => $s['data_programmazione'] )
                    )
                );

                $status['info'][] = 'inserite ' . $raa . ' righe dalla tabella __report_attivita_assenze__';
                
                // aggiorno l'attività settando id_anagrafica NULL
                $u = mysqlQuery( 
                    $cf['mysql']['connection'],
                    'UPDATE attivita SET id_anagrafica = NULL WHERE id = ?',
                    array( array( 's' => $s['id']) )
                );

                $status['info']['righe_aggiornate'] += $u;
            }
        }
        
        // aggiorno le attività coinvolte settando id_anagrafica NULL
    /*    $u = mysqlQuery( 
            $cf['mysql']['connection'],
            "UPDATE attivita LEFT JOIN todo ON todo.id = attivita.id_todo SET attivita.id_anagrafica = NULL "
            ."WHERE attivita.id_anagrafica = ? "
            ."AND ( ( coalesce( TIMESTAMP( attivita.data_programmazione, attivita.ora_inizio_programmazione ), TIMESTAMP( todo.data_programmazione, todo.ora_inizio_programmazione ) ) between ? and ? ) "
            ."OR ( coalesce( TIMESTAMP( attivita.data_programmazione, attivita.ora_fine_programmazione ), TIMESTAMP( todo.data_programmazione, todo.ora_fine_programmazione ) ) between ? and ? ) )"
        ,
            array(
                array( 's' =>  $p['id_anagrafica'] ),
                array( 's' =>  $data_ora_inizio ),
                array( 's' =>  $data_ora_fine ),
                array( 's' =>  $data_ora_inizio ),
                array( 's' =>  $data_ora_fine )
            )
        );
*/
        // status
    #    $status['info'][] = 'aggiornate ' . $u . ' righe dalla tabella attivita per il periodo ' . $p['data_inizio'] . ' ' . $p['ora_inizio'] . ' - ' . $p['data_fine'] . ' ' . $p['ora_fine'];          

        // setto la riga come elaborata
        $u = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE periodi_variazioni_attivita SET timestamp_controllo_attivita = ? WHERE id = ?',
            array(
                array( 's' => time() ),
                array( 's' => $p['id'] )
            )
        );

        $status['info'][] = 'settaggio riga come elaborata ' . $u;
		
    }
    else{
        $status['info'][] = 'nessun periodo da elaborare';
    }
        

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
