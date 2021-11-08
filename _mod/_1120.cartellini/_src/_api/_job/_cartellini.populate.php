<?php

    /**
     * 
     *  
     * 
     */
#gdl
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

                $status['result'] = mysqlSelectColumn(
				    'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM cartellini WHERE data_attivita >= ? AND  data_attivita <= ?',
                    array(
                        array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-01") ) ),
                        array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-31") ) )
                    )

                );

                logWrite( 'trovati  ' . count( $status['result'] ).' cartellini per il mese   '.$mese.'/'.$anno , 'cartellini', LOG_ERR );
          
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

            // recupero i dati del cartellino
            $cartellino = mysqlSelectRow(
                        $cf['mysql']['connection'], 
                        'SELECT * FROM cartellini WHERE id = ? ',
                        array( array( 's' => $cid ) ) );

            logWrite( 'lavoro il cartellino ' . $cid , 'cartellini', LOG_ERR );

            // verifico quante ore il soggetto ha fatto nel guiorno indicato
            $ore = mysqlSelectValue(
                $cf['mysql']['connection'], 
                'SELECT SUM(ore) FROM attivita WHERE id_anagrafica = ? AND data_attivita = ? AND id_tipologia_inps = ?',
                array( array( 's' => $cartellino['id_anagrafica'] ), array( 's' => $cartellino['data_attivita'] ),array( 's' => $cartellino['id_tipologia_inps'] ) )
            );

            if( !empty ( $ore ) ){
   
                logWrite( 'il cartellino ' . $cid.' ha  '.$ore.' effettivamente lavorate ' , 'cartellini', LOG_ERR );

                    $update_cartellino = mysqlQuery( $cf['mysql']['connection'], 
                    'UPDATE cartellini SET ore_fatte = ?, timestamp_aggiornamento = ? WHERE id = ? ',
                    array( 
                        array( 's' => $ore ), 
                        array( 's' => time() ),
                        array( 's' => $cid ) ) 
                    );

            } else {
                logWrite( 'il cartellino non ha ore lavorate ' , 'cartellini', LOG_ERR );

                $update_cartellino = mysqlQuery( $cf['mysql']['connection'], 
                'UPDATE cartellini SET ore_fatte = ?, timestamp_aggiornamento = ? WHERE id = ? ',
                array( 
                    array( 's' => 0 ), 
                    array( 's' => time() ),
                    array( 's' => $cid ) ) 
                );
            }
                    // TODO: ore fascia oraria
            /*        $ore = mysqlQuery(  $cf['mysql']['connection'], 
                    'SELECT ora_inizio, ora_fine  FROM fasce_orari_contratti WHERE fasce_orari_contratti.id_contratto = ? AND fasce_orari_contratti.id_tipologia_inps = ? ',
                    array( array( 's' => $cartellino['id_contratto'] ) ) );


                    // TODO aggiorno i cartellini

          */

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
