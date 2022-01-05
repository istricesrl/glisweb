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
        if( isset( $job['corrente'] ) && $job['corrente'] >= $job['totale'] ) {

            // status
            $status['info'][] = 'iterazione a vuoto su job già completato';

        } elseif( !isset(  $job['workspace']['mese'] ) || !isset(  $job['workspace']['anno'] ) ){
            $status['err'][] = 'mese o anno non settati';
        } else {

            // attività di avvio
            if( empty( $job['corrente'] ) ) {

                // logiche di calcolo...
                $mese = $job['workspace']['mese'];
                $anno = $job['workspace']['anno'];

                logWrite( 'lavoro i cartellini dal '.date( 'Y-m-d', strtotime("$anno-$mese-01")).' al '.date( 'Y-m-t', strtotime("$anno-$mese-01")) , 'cartellini', LOG_ERR );
                // tutti i contratti validi in parte o del tutto nel mese/anno indicato
                $status['result'] = mysqlSelectColumn(
				    'id_anagrafica',
                    $cf['mysql']['connection'],
                    'SELECT DISTINCT id_anagrafica FROM contratti WHERE ( data_inizio BETWEEN ? AND ? ) '.
                    'OR ( data_inizio < ? AND '.
                    '( data_fine_rapporto IS NULL AND ( data_fine IS NULL OR ( data_fine IS NOT NULL and data_fine >= ? ) ) ) )',
                    array(
                        array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-01") ) ),
                        array( 's' => date( 'Y-m-t', strtotime("$anno-$mese-01") ) ), // Y-m-t restituisce l'unltimo giorno del mese per l'anno indicato
                        array( 's' => date( 'Y-m-t', strtotime("$anno-$mese-01") ) ),
                        array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-01") ) )
                    )
                );
                           
                // creo la lista dei contratti attivi su cui generare cartellini teorici
                $job['workspace']['list'] = $status['result'];

                // segno il totale dei contratti da lavorare
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

                // mando un messaggio su Slack
                slackTxtMsg( $cf['slack']['profile']['webhooks']['default'], 'avviata ' . $job['nome'] );

            } else {

                // incremento l'indice di lavoro
                $job['corrente']++;

            }

            // aggiusto l'indice di lavoro (gli array partono da zero)
            $widx = $job['corrente'] - 1;

            // ricavo l'ID del contratto corrente
            $cid = $job['workspace']['list'][ $widx ];
			
		// logiche di calcolo...
            $mese = $job['workspace']['mese'];
            $anno = $job['workspace']['anno'];

            // richiamo il task cartellini.generate
            $url = $cf['site']['url'] . '_mod/_1120.cartellini/_src/_api/_task/_cartellini.generate.php?mese=' . $mese . '&anno=' . $anno . '&id_anagrafica=' . $cid;

            $status[$cid]['esecuzione'] = restcall( $url );
          
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

                // scrivo la timestamp di completamento
                $jobs = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE job SET timestamp_completamento = ? WHERE id = ?',
                    array(
                    array( 's' => time() ),
                    array( 's' => $job['id'] )
                    )
                );

                // creo il per popolare i cartellini appena creati
                $status['job'] = mysqlQuery(
                    $cf['mysql']['connection'],
                    'INSERT INTO job ( nome, job, iterazioni, workspace, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ? )',
                    array(
                        array( 's' => 'popolazione cartellini ' . $job['workspace']['mese'] . '/' . $job['workspace']['anno'] ),
                        array( 's' => '_mod/_1120.cartellini/_src/_api/_job/_cartellini.populate.php' ),
                        array( 's' => 2 ),
                        array( 's' => json_encode(
                            array(
                                'mese' => $job['workspace']['mese'],
                                'anno' => $job['workspace']['anno']
                            )
                        ) ),
                        array( 's' => time() )
                    )
                );

                $status['info'][] = 'ho inserito il job: ' .$status['job'];
                // mando un messaggio su Slack
                slackTxtMsg( $cf['slack']['profile']['webhooks']['default'], 'completata ' . $job['nome'] );

            }

        }

    } else {

        // status
		$status['error'][] = 'questo job non può essere lanciato fuori dal cron';

        // output
        buildJson( $status );

    }
