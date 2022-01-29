<?php

    /**
     * job in foreground che viene creato dal task _variazioni.attivita.approve.php
     * analizza una riga di variazioni_attivita approvata
     * - verifica se ci sono attività in quel periodo assegnate all'anagrafica corrispondente e:
     *      - setta id_anagrafica NULL
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

     // inizializzo l'array del risultato
	$status = array();

    // lavoro lungo
    set_time_limit( 0 );

    // inclusione del framework
	if( defined( 'CRON_RUNNING' )  || defined( 'JOB_RUNNING' ) ) {

        // verifiche formali (questo per gestire il caso di ciclo a vuoto)
        if( isset( $job['corrente'] ) && $job['corrente'] >= $job['totale'] ) {

            // status
            $status['info'][] = 'iterazione a vuoto su job completato';

        } 
        elseif( !isset(  $job['workspace']['id_variazione'] ) ){
            $status['err'][] = 'id_variazione non settato';
        }
        else {

            // attività di avvio
            if( empty( $job['corrente'] ) ) {

                // chiave di lock
	            $status['tk'] = getToken( __FILE__ );

                // metto il lock sui periodi della variazione che non hanno già un token
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE periodi_variazioni_attivita SET token = ? WHERE id_variazione = ? AND token IS NULL',
                    array(
                        array( 's' => $status['tk'] ),
                        array( 's' => $job['workspace']['id_variazione'] )
                    )
                );

                // leggo i periodi da elaborare
                $periodi = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT pv.*, v.id_anagrafica FROM periodi_variazioni_attivita AS pv LEFT JOIN variazioni_attivita AS v ON pv.id_variazione = v.id WHERE v.id = ? AND pv.token = ?',
                    array( 
                        array( 's' => $job['workspace']['id_variazione'] ),
                        array( 's' => $status['tk'] )
                    )
                );

                $status['result'] = array();

                if( !empty( $periodi ) ){
                    foreach( $periodi as $p ){
                        // se l'ora inizio non è settata parto dalla mezzanotte, idem per l'ora fine
                        if( empty( $p['ora_inizio'] ) ){
                            $p['ora_inizio'] = '00:00:01';
                        }
                        if( empty( $p['ora_fine'] ) ){
                            $p['ora_fine'] = '23:59:59';
                        }

                        $data_ora_inizio = $p['data_inizio'] . ' ' . $p['ora_inizio'];
                        $data_ora_fine = $p['data_fine'] . ' ' . $p['ora_fine'];

                        $status['data_ora_inizio'] = $data_ora_inizio;
                        $status['data_ora_fine'] = $data_ora_fine;

                        // elenco id delle attività che rimangono scoperte
                        $attivita = mysqlSelectColumn(
                            'id',
                            $cf['mysql']['connection'],
                            'SELECT id FROM attivita '
                            .'WHERE id_anagrafica = ? '
                            .'AND ( ( TIMESTAMP( data_programmazione, ora_inizio_programmazione ) between ? and ? ) '
                            .'OR ( TIMESTAMP( data_programmazione, ora_fine_programmazione ) between ? and ? ) )',
                            array(
                                array( 's' =>  $p['id_anagrafica'] ),
                                array( 's' =>  $data_ora_inizio ),
                                array( 's' =>  $data_ora_fine ),
                                array( 's' =>  $data_ora_inizio ),
                                array( 's' =>  $data_ora_fine )
                            )
                        );

                        if( !empty( $attivita ) ){
                            $status['result'] = array_merge( $attivita, $status['result'] );
                        }
                    }
                }
                            
                // creo la lista delle attività da lavorare
                $job['workspace']['list'] = $status['result'];

                // segno il totale delle attività da lavorare
                $job['totale'] = count( $job['workspace']['list'] );

                // avvio il contatore
                $job['corrente'] = 1;

                // timestamp di avvio
                if( empty( $job['timestamp_apertura'] ) ) {
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'UPDATE job SET timestamp_apertura = ? WHERE id = ?',
                        array(
                        array( 's' => time() ),
                        array( 's' => $job['id'] )
                        )
                    );
                }

            } else {

                // incremento l'indice di lavoro
                $job['corrente']++;

            }

            // aggiusto l'indice di lavoro (gli array partono da zero)
            $widx = $job['corrente'] - 1;

            // ricavo l'ID del progetto corrente
            $cid = $job['workspace']['list'][ $widx ];
			
			// logiche di calcolo
            // estraggo i dati che mi occorrono per la riga di attività corrente
            $a = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT id_progetto, id_anagrafica, data_programmazione FROM attivita WHERE id = ?',
                array( array( 's' => $cid ) )
            );


            $raa = mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT IGNORE INTO __report_attivita_assenze__ ( id_attivita, id_anagrafica, data_assenza ) VALUES ( ?, ?, ? )',
                array(
                    array( 's' => $cid ),
                    array( 's' => $a['id_anagrafica'] ),
                    array( 's' => $a['data_programmazione'] )
                )
            );

            $status['info'][] = 'inserite righe dalla tabella __report_attivita_assenze__';
            
            // TODO: gestire il caso in cui l'attività sia coinvolta solo parzialmente > scorporarla creando più attività e scoprire solo la fascia oraria coinvolta

            // aggiorno l'attività settando id_anagrafica NULL
            $u = mysqlQuery( 
                $cf['mysql']['connection'],
                'UPDATE attivita SET id_anagrafica = NULL WHERE id = ?',
                array( array( 's' => $cid ) )
            );

            // status
            $status['info'][] = 'ho lavorato la riga: ' . $cid;

            // aggiorno i valori di visualizzazione avanzamento
            $jobs = mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE job SET totale = ?, corrente = ? WHERE id = ?',
                array(
                array( 's' => $job['totale'] ),
                array( 's' => $job['corrente'] ),
                array( 's' => $job['id'] )
                )
            );

            // operazioni di chiusura
            if( $job['corrente'] >= $job['totale'] ) {

                // estraggo le attività della tabella __report_sostituzioni_attivita__ in cui è coinvolta l'anagrafica corrente
                $report = mysqlSelectColumn(
                    'id_attivita',
                    $cf['mysql']['connection'],
                    'SELECT id_attivita FROM __report_sostituzioni_attivita__ WHERE id_anagrafica = ?',
                    array(
                        array( 's' =>  $a['id_anagrafica'] )
                    )
                );

            #    $status['attivita_report'] = $report;

                if( !empty( $report ) ){
                    foreach( $report as $rid ){
                    #    $status['attivita_da_aggiornare'][] = $rid;
                        mysqlQuery(
                            $cf['mysql']['connection'],
                            'UPDATE attivita SET timestamp_calcolo_sostituti = NULL WHERE id = ?',
                            array( array( 's' => $rid ) )
                        );
                    }
                }

                $status['info'][] = 'rimuovo le righe sulla __report_sostituzioni_attivita__ legate a questa anagrafica';

                // rimuovo le righe sulla __report_sostituzioni_attivita__ legate a questa anagrafica
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'DELETE FROM __report_sostituzioni_attivita__ WHERE id_anagrafica = ?',
                    array(
                        array( 's' =>  $a['id_anagrafica'] )
                    )
                );

                $status['info'][] = 'setto le righe di periodi_variazioni_attivita come elaborate';

                // setto le righe di periodo come elaborate
                $elab = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE periodi_variazioni_attivita SET timestamp_controllo_attivita = ?, token = NULL WHERE id_variazione = ?',
                    array(
                        array( 's' => time() ),
                        array( 's' => $job['workspace']['id_variazione'] )
                    )
                );

                // inserisco una richiesta di ripopolamento delle statiche
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'INSERT INTO refresh_view_statiche (entita, note, timestamp_prenotazione) VALUES( ?, ?, ? )',
                    array(
                        array( 's' => 'attivita' ),
                        array( 's' => '_mod/_1140.variazioni/_src/_api/_job/_variazioni.attivita.update.php'),
                        array( 's' => time() )
                    )
                );

                $status['info'][] = 'scrivo la timestamp di completamento';
                // scrivo la timestamp di completamento
                $jobs = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE job SET timestamp_completamento = ? WHERE id = ?',
                    array(
                    array( 's' => time() ),
                    array( 's' => $job['id'] )
                    )
                );


            }

        }

    } else {

        // status
		$status['error'][] = 'questo job non può essere lanciato fuori dal cron';

        // output
        buildJson( $status );

    }
