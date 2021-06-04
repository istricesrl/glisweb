<?php

    /**
     * 
     *  
     * 
     */

    // inizializzo l'array del risultato
	$status = array();

    // lavoro lungo
    set_time_limit( 0 );

    // inclusione del framework
	if( defined( 'CRON_RUNNING' )  || defined( 'JOB_RUNNING' ) ) {

        // verifiche formali (questo per gestire il caso di ciclo a vuoto)
        if( isset( $job['corrente'] ) && $job['corrente'] == $job['totale'] ) {

            // status
            $status['info'][] = 'iterazione a vuoto su job già completato';

        } 
        elseif( !isset(  $job['workspace']['id_variazione'] ) ){
            $status['err'][] = 'id_variazione non settato';
        }
        else {

            // attività di avvio
            if( empty( $job['corrente'] ) ) {

                $status['result'] = mysqlSelectColumn(
				    'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM periodi_variazioni_attivita WHERE id_variazione = ?',
                    array( 's' => $job['workspace']['id_variazione'] )
                );
                             
                // creo la lista dei progetti da lavorare
                $job['workspace']['list'] = $status['result'];

                // segno il totale dei progetti da lavorare
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
			
			// logiche di calcolo e scrittura nel report
            triggerOff( 'attivita', '_mod/_1140.variazioni/_src/_api/_job/_variazioni.attivita.approve.php' );
            $cf['cron']['cache']['view']['static']['refresh'][] = 'attivita';

            // chiamo il task _variazioni.attivita.update che setta id_anagrafica NULL per le attività coinvolte
            $url = $cf['site']['url'] . '_mod/_1140.variazioni/_src/_api/_task/_variazioni.attivita.update.php?id=' . $cid;

            $status['update_attivita'][$cid] = restcall(
                $url
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
            if( $job['corrente'] == $job['totale'] ) {

                // estraggo id_anagrafica per la variazione corrente
                $id_anagrafica = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT id_anagrafica FROM variazioni_attivita WHERE id = ?',
                    array( array( 's' => $cid ) )
                );
               
                // rimuovo le righe sulla __report_sostituzioni_attivita__ legate a questa anagrafica
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'DELETE FROM __report_sostituzioni_attivita__ WHERE id_anagrafica = ?',
                    array(
                        array( 's' =>  $id_anagrafica )
                    )
                );


                // scrivo la timestamp di completamento
                $jobs = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE job SET timestamp_completamento = ? WHERE id = ?',
                    array(
                    array( 's' => $time ),
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
