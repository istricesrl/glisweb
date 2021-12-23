<?php

    /**
     * task che gira autonomamente > preleva una riga di periodi_variazioni_attivita per le variazioni approvate  * 
     *      - verifica se ci sono attività in quel periodo assegnate all'anagrafica corrispondente e:
     *      - setta id_anagrafica NULL
     *      - se presente una riga di __acl_attivita__ per l'account dell'anagrafica, la elimina
     *      - crea una riga nella tabella di report __report_attivita_assenze__
     *      - aggiorna il timestamp_controllo_attivita per i periodi_variazioni_attivita figli
     *      - legge le attività della tabella __report_sostituzioni_attivita__ in cui l'anagrafica è stata coinvolta e azzera il timestamp_calcolo_sostituti per quelle attvità
     *      - elimina le righe __report_sostituzioni_attivita__ per l'anagrafica
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
            .'WHERE v.data_approvazione IS NOT NULL AND pv.token IS NULL '
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

                $status['info'][] = 'presenti attivita da scoprire';
                
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
                
                // verifico se l'anagrafica ha un account associato per eliminare l'eventuale riga di acl corrispondente
                $id_account = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT id FROM account WHERE id_anagrafica = ?',
                    array( array( 's' => $p['id_anagrafica'] ) )
                );

                // aggiorno l'attività settando id_anagrafica NULL
                $u = mysqlQuery( 
                    $cf['mysql']['connection'],
                    'UPDATE attivita SET id_anagrafica = NULL WHERE id = ?',
                    array( array( 's' => $s['id']) )
                );

                // elimino la riga di acl
                if( !empty( $id_account ) ){
                    $status['info'][] = 'elimino le righe di acl per l\'account ' . $id_account . ' e l\'entità ' . $s['id'];
                    $acl = mysqlQuery(
                        $cf['mysql']['connection'],
                        'DELETE FROM __acl_attivita__ '
                        .'WHERE id_account = ? AND id_entita = ?',
                        array( 
                            array( 's' => $id_account ),
                            array( 's' => $s['id'] )
                        )
                    );
                }

                $status['info']['righe_aggiornate'] += $u;
            }

            // inserisco una richiesta di ripopolamento delle statiche
            mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT INTO refresh_view_statiche (entita, note, timestamp_prenotazione) VALUES( ?, ?, ? )',
                array(
                    array( 's' => 'attivita' ),
                    array( 's' => '_mod/_1140.variazioni/_src/_api/_task/_variazioni.attivita.update.php'),
                    array( 's' => time() )
                )
            );
            

            // estraggo le attività della tabella __report_sostituzioni_attivita__ in cui è coinvolta l'anagrafica corrente
            $report = mysqlSelectColumn(
                'id_attivita',
                $cf['mysql']['connection'],
                'SELECT id_attivita FROM __report_sostituzioni_attivita__ WHERE id_anagrafica = ?',
                array(
                    array( 's' =>  $p['id_anagrafica'] )
                )
            );

        #    $status['attivita_ricalcolo_sostituti'] = $report;

            if( !empty( $report ) ){
                foreach( $report as $rid ){
                #    $status['attivita_aggiorno_timestamp'][] = $rid;
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'UPDATE attivita SET timestamp_calcolo_sostituti = NULL WHERE id = ?',
                        array( array( 's' => $rid ) )
                    );
                }
            }

            $status['info'][] = 'rimuovo le righe da __report_sostituzioni_attivita__ per l\'anagrafica coinvolta';

            // rimuovo le righe sulla __report_sostituzioni_attivita__ legate a questa anagrafica
            mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE FROM __report_sostituzioni_attivita__ WHERE id_anagrafica = ?',
                array(
                    array( 's' =>  $p['id_anagrafica'] )
                )
            );

        }
    
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
