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
	if( defined( 'CRON_RUNNING' ) || defined( 'JOB_RUNNING' ) ) {

        // verifiche formali (questo per gestire il caso di ciclo a vuoto)
        if( isset( $job['corrente'] ) && $job['corrente'] == $job['totale'] ) {

            // status
            $status['info'][] = 'iterazione a vuoto su job già completato';

        } 
        elseif( !isset( $job['workspace']['id_progetto'] ) || !isset( $job['workspace']['id_anagrafica'] ) ){
            $status['err'][] = 'id_progetto o id_anagrafica non settati';
        }
        else {

            // attività di avvio
            if( empty( $job['corrente'] ) ) {

                $status['result'] = mysqlSelectColumn(
				    'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM attivita WHERE id_progetto = ? AND id_anagrafica IS NULL',
                    array( array( 's' => $job['workspace']['id_progetto'] ) )
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
            }
            else {

                // incremento l'indice di lavoro
                $job['corrente']++;

            }

            triggerOff( 'attivita', '_mod/_1140.variazioni/_src/_api/_job/_sostituzioni.progetto.request.php' );
            $cf['cron']['cache']['view']['static']['refresh'][] = 'attivita';

            // aggiusto l'indice di lavoro (gli array partono da zero)
            $widx = $job['corrente'] - 1;

            // ricavo l'ID del progetto corrente
            $cid = $job['workspace']['list'][ $widx ];
            $id_anagrafica =  $job['workspace']['id_anagrafica'];

            // logiche di calcolo
            $copertura = coperturaAttivita( $id_anagrafica, $cid );

            if( $copertura == 1){
                
                // verifico se ci sono già delle richieste di sostituzione
                $richieste = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT count(*) FROM sostituzioni_attivita WHERE id_anagrafica = ? AND id_attivita = ?',
                    array(
                        array( 's' => $id_anagrafica ),
                        array( 's' => $cid )
                    )
                );
                
                // se non c'è già una richiesta la creo
                if( empty( $richieste ) ){
                    $url = $cf['site']['url'] . '_mod/_1140.variazioni/_src/_api/_task/_sostituzioni.request.php?id_attivita=' . $cid . '&id_anagrafica=' . $id_anagrafica;
                    
                    // se la richiesta arriva in modalità hard aggiungo il parametro per creare le attività
                    if( !empty( $job['workspace']['hard'] ) ){
                        $status['hard'] =  $job['workspace']['hard'];
                        $url .= '&hard=1';
                    }
                    $status['attivita'][$cid]['creazione_richiesta'] = restcall(
                        $url
                    );
                }
            }

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
                $status['info'][] = 'ho finito';
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
