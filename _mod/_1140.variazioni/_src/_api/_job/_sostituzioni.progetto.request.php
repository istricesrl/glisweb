<?php

    /**
     * 
     *  job che crea le richieste di sostituzione per le attività scoperte di un dato progetto con una determinata anagrafica, se questa può coprirle
     *  
     *  riceve in ingresso nel workspace i parametri seguenti:
     * 
     *  @param id_progetto              id del progetto
     *  @param id_anagrafica            id dell'anagrafica
     *  @param data_inizio,data_fine    se settati, il job analizza solo le attività con data_programmazione compresa in tale range
     *  @param ora_inizio,ora_fine      se settati, il job analizza solo le attività con ora_inizio_programmazione e ora_fine_programmazione pari a tali valori
     *  @param hard                     se settato, il job forza la sostituzione settando la richiesta come accettata
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
        elseif( !isset( $job['workspace']['id_progetto'] ) || !isset( $job['workspace']['id_anagrafica'] ) ){
            $status['err'][] = 'id_progetto o id_anagrafica non settati';
        }
        else {

            // attività di avvio
            if( empty( $job['corrente'] ) ) {

                // inizializzo gli array delle condizioni where e dei parametri
                $whr = array();
                $par = array();

                // progetto
                $whr[] = 'id_progetto = ?';
                $par[] = array( 's' => $job['workspace']['id_progetto'] );


                if( !empty( $job['workspace']['data_inizio'] ) && !empty( $job['workspace']['data_fine'] ) ){
                    $whr[] = 'data_programmazione BETWEEN ? AND ?';
                    $par[] = array( 's' => $job['workspace']['data_inizio'] );
                    $par[] = array( 's' => $job['workspace']['data_fine'] );
                }

                if( !empty( $job['workspace']['ora_inizio'] ) && !empty( $job['workspace']['ora_fine'] ) ){
                    $whr[] = 'ora_inizio_programmazione = ?';
                    $whr[] = 'ora_fine_programmazione = ?';
                    $par[] = array( 's' => $job['workspace']['ora_inizio'] );
                    $par[] = array( 's' => $job['workspace']['ora_fine'] );
                }

                $q = 'SELECT id FROM attivita WHERE id_anagrafica IS NULL AND ('  . implode( ' AND ', $whr ) . ')';

                $status['query'] = $q;
                $status['parametri'] = $par;

                // seleziono le attività coinvolte
                $status['result'] = mysqlSelectColumn(
                    'id',
                    $cf['mysql']['connection'],
                    $q,
                    $par
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
