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
				    'data_attivita',
                    $cf['mysql']['connection'],
                    'SELECT DISTINCT data_attivita FROM cartellini WHERE data_attivita >= ? AND  data_attivita <= ?',
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
            $cartellini = mysqlSelectRow(
                        $cf['mysql']['connection'], 
                        'SELECT * FROM cartellini WHERE data_attivita = ? ',
                        array( array( 's' => $cid ) ) );

            logWrite( 'trovati ' . count( $cartellini ) .' per la data '.$cid , 'cartellini', LOG_ERR );

            foreach( $cartellini as $car ){

                // ricavo l'id del contratto attivo alla data indicata
                $contratto = contrattoAttivo( $car['id_anagrafica'], $cid );

                // verifico se c'è un turno specificato nella tabella turni
                $turno = mysqlSelectValue(
                    $cf['mysql']['connection'], 
                    'SELECT turno FROM turni WHERE id_contratto = ? AND (data_inizio <= ? AND data_fine >= ?) ORDER BY id DESC LIMIT 1',
                    array( 
                        array( 's' => $contratto ),
                        array( 's' => $cid ),
                        array( 's' => $cid )
                    )
                );
            
                // se non ci sono turni, di base è attivo il turno 1
                if( empty( $turno ) ){
                    $turno = 1;
                }

                $fasce = mysqlSelectRow(
                    $cf['mysql']['connection'],  
                    'SELECT * FROM fasce_orari_contratti WHERE id_contratto = ? AND id_turno = ? AND giorno = ? LIMIT 1',
                    array(
                        array( 's' => $contratto ),
                        array( 's' => $turno ),
                        array( 's' => ( date( 'w', strtotime("$cid") ) == 0 ) ? '7' : date( 'w', strtotime("$cid") ) )
                    )
                );

                // LAVORO ORDINARIO
                // tutte le attività svolte nella fascia oraria del giorno
                $oreOrdinarie = mysqlQuery( 
                    $cf['mysql']['connection'], 
                    'SELECT sum(ore) as tot_ore FROM attivita ' .
                    'WHERE data_attivita = ? and id_anagrafica = ? AND ora_inizio >= ? AND ora_fine <= ? GROUP by data_attivita',
                    array(
                        array( 's' => $cid ),
                        array( 's' => $car['id_anagrafica'] ),
                        array( 's' => $fasce['ora_inizio'] ),
                        array( 's' => $fasce['ora_fine'] )
                    )			
                );

                // LAVORO STRAORDINARIO
                // tutte le attività svolte nella fascia oraria del giorno
                $oreStraordinarie = mysqlQuery( 
                    $cf['mysql']['connection'], 
                    'SELECT sum(ore) as tot_ore FROM attivita ' .
                    'WHERE data_attivita = ? and id_anagrafica = ? AND (ora_inizio < ? OR ora_fine > ?) GROUP by data_attivita',
                    array(
                        array( 's' => $cid ),
                        array( 's' => $car['id_anagrafica'] ),
                        array( 's' => $fasce['ora_inizio'] ),
                        array( 's' => $fasce['ora_fine'] )
                    )			
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

                } /*else {

                    logWrite( 'il cartellino non ha ore lavorate ' , 'cartellini', LOG_ERR );

                    $update_cartellino = mysqlQuery( $cf['mysql']['connection'], 
                    'UPDATE cartellini SET ore_fatte = ?, timestamp_aggiornamento = ? WHERE id = ? ',
                    array( 
                        array( 's' => 0 ), 
                        array( 's' => time() ),
                        array( 's' => $cid ) ) 
                    );
                }*/

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

            }

            // status
            $status['info'][] = 'ho lavorato la data: ' . $cid;

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
