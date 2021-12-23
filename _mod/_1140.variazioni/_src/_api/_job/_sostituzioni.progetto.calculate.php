<?php

    /**
     * job che legge tutte le attività senza anagrafica e con token = NULL per un dato progetto e richiama la funzione sostitutiAttività che calcola i sostituti per ognuna
     * nel workspace sono definiti i parametri seguenti:
     * 
     * @param	string	id_progetto		id del progetto su cui lavorare
     * @param	int	    hard		    se settato a 1, significa che è richiesto un ricalcolo, quindi per prima cosa il job elimina dalla tabella 
     * 
     */

    // inizializzo l'array del risultato
	$status = array();

    // lavoro lungo
    set_time_limit( 0 );

    // inclusione del framework
	if( defined( 'CRON_RUNNING' ) || defined( 'JOB_RUNNING' ) ) {

        // verifiche formali (questo per gestire il caso di ciclo a vuoto)
        if( isset( $job['corrente'] ) && $job['corrente'] >= $job['totale'] ) {

            // status
            $status['info'][] = 'iterazione a vuoto su job completato';

        } 
        elseif( !isset( $job['workspace']['id_progetto'] ) ){
            $status['err'][] = 'id_progetto non settato';
        }
        else {

            // attività di avvio
            if( empty( $job['corrente'] ) ) {

                // chiave di lock
	            $status['tk'] = getToken( __FILE__ );

                // se è richiesto il ricalcolo, elimino i calcoli già effettuati dalla tabella __report_sostituti_attivita__
                if( !empty( $job['workspace']['hard'] ) ){
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'DELETE r FROM `__report_sostituzioni_attivita__` AS r INNER JOIN attivita as a on r.id_attivita = a.id WHERE a.id_progetto = ?',
                        array(
                            array( 's' => $job['workspace']['id_progetto'] )
                        )
                    );
                }
                
                // metto il lock sulle attività scoperte del progetto che non hanno già un token
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE attivita SET token = ? WHERE id_anagrafica IS NULL AND id_progetto = ? AND token IS NULL',
                    array(
                        array( 's' => $status['tk'] ),
                        array( 's' => $job['workspace']['id_progetto'] )
                    )
                );

                $status['result'] = mysqlSelectColumn(
				    'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM attivita WHERE id_progetto = ? AND id_anagrafica IS NULL AND token= ?',
                    array( 
                        array( 's' => $job['workspace']['id_progetto'] ),
                        array( 's' => $status['tk'] )
                    )
                );

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
            }
            else {

                // incremento l'indice di lavoro
                $job['corrente']++;

            }

            // aggiusto l'indice di lavoro (gli array partono da zero)
            $widx = $job['corrente'] - 1;

            // ricavo l'ID dell'attività corrente
            $cid = $job['workspace']['list'][ $widx ];

            // logiche di calcolo
            sostitutiAttivita( $cid );

            // rilascio il token
            $status['sblocco'] = mysqlQuery( 
                $cf['mysql']['connection'],
                'UPDATE attivita SET timestamp_aggiornamento = ?, timestamp_calcolo_sostituti = ?, token = NULL WHERE id = ?', 
                array(
                    array( 's' => time() ),
                    array( 's' => time() ),
                    array( 's' => $cid )
                )
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
