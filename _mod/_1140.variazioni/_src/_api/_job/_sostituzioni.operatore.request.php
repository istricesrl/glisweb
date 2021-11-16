<?php

    /**
     * 
     * job in foreground creato per sostituire tutte le attività lasciate scoperte da un operatore con un altro
     * riceve in ingresso nel workspace i parametri seguenti:
     *  @param id_assente                 id dell'operatore da sostituire
     *  @param id_sostituto               id dell'operatore sostituto
     *  @param data_inizio,data_fine      se settati, il job analizza solo le attività con data_programmazione compresa in tale range
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
            $status['info'][] = 'iterazione a vuoto su job già completato';

        } 
        elseif( !isset( $job['workspace']['id_assente'] ) || !isset( $job['workspace']['id_sostituto'] ) ){
            $status['err'][] = 'id_assente o id_sostituto non settati';
        }
        else {

            // attività di avvio
            if( empty( $job['corrente'] ) ) {

                // query da eseguire
                $q = 'SELECT a.id FROM attivita as a INNER JOIN __report_attivita_assenze__ as r ON a.id = r.id_attivita AND r.id_anagrafica = ? AND a.id_anagrafica IS NULL';
                
                // array dei parametri
                $par = array(
                    array( 's' => $job['workspace']['id_assente'] )
                );

                if( ! empty( $job['workspace']['data_inizio'] ) && ! empty( $job['workspace']['data_fine'] ) ){
                    $status['data_inizio'] = $job['workspace']['data_inizio'];
                    $status['data_fine'] = $job['workspace']['data_fine'];

                    $q .= ' WHERE a.data_programmazione BETWEEN ? and ?';
                    $par[] = array( 's' => $job['workspace']['data_inizio'] );
                    $par[] = array( 's' => $job['workspace']['data_fine'] );
                }

                $status['query'] = $q;
                $status['parametri'] = $par;

                // seleziono le attività coinvolte
                $status['result'] = mysqlSelectColumn(
                    'id',
                    $cf['mysql']['connection'],
                    $q,
                    $par
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

            // aggiusto l'indice di lavoro (gli array partono da zero)
            $widx = $job['corrente'] - 1;

            // ricavo l'ID dell'attività corrente
            $cid = $job['workspace']['list'][ $widx ];
            $id_anagrafica =  $job['workspace']['id_sostituto'];

            // logiche di calcolo
            $copertura = coperturaAttivita( $id_anagrafica, $cid );

            if( $copertura == 1){

                $status['info'][] = 'l\'operatore può coprire l\'attività ' . $cid;
                
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
                    
                    // se la richiesta arriva in modalità hard aggiungo il parametro per aggiornare l'attività e settare la sostituzione
                    if( !empty( $job['workspace']['hard'] ) ){
                        $status['hard'] =  $job['workspace']['hard'];
                        $url .= '&hard=1';
                    }
                    $status['attivita'][$cid]['creazione_richiesta'] = restcall(
                        $url
                    );
                }
            }
            else{
                $status['info'][] = 'l\'operatore non può coprire l\'attività ' . $cid;
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

        appendToFile( print_r( $status, true ), 'var/log/sostituzioni_operatore/job_#'.$job['id'] . '.log' );

    } else {

        // status
		$status['error'][] = 'questo job non può essere lanciato fuori dal cron';

        // output
        buildJson( $status );

    }
