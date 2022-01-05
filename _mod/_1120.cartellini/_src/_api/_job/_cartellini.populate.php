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

            logWrite( 'inizio popolamento cartellini', 'cartellini', LOG_ERR );

            // attività di avvio
            if( empty( $job['corrente'] ) ) {

                // logiche di calcolo...
                $mese = $job['workspace']['mese'];
                $anno = $job['workspace']['anno'];

                $status['result'] = mysqlSelectColumn(
				    'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM cartellini WHERE mese = ? AND  anno = ?',
                    array(
                        array( 's' =>$mese ) ,
                        array( 's' => $anno ) 
                    )
                );

                logWrite( 'trovate ' . count( $status['result'] ).' cartellini per il mese '.$mese.'/'.$anno , 'cartellini', LOG_ERR );
          
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

            // ricavo l'ID del cartellino corrente
            $cid = $job['workspace']['list'][ $widx ];
			
		// logiche di calcolo...
            // richiamo il task cartellini.populate
            $url = $cf['site']['url'] . '_mod/_1120.cartellini/_src/_api/_task/_cartellini.populate.php?id_cartellino=' . $cid;
            $status[$cid]['esecuzione'] = restcall( $url );

            // status
            $status['info'][] = 'ho lavorato la data: ' . $cid;

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
