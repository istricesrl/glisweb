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

                // tutti i contratti validi in parte o del tutto nel mese/anno indicato
                $status['result'] = mysqlSelectColumn(
				    'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM contratti WHERE ( data_inizio_rapporto BETWEEN ? AND ? ) '.
                    'OR ( data_inizio_rapporto < ? AND '.
                    '( data_fine_rapporto IS NULL AND ( data_fine IS NULL OR ( data_fine IS NOT NULL and data_fine >= ? ) ) ) )',
                    array(
                        array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-01") ) ),
                        array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-31") ) ),
                        array( 's' => date( 'Y-m-d', strtotime("$anno-$mese-01") ) ),
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
           //     slackTxtMsg( $cf['slack']['profile']['webhooks']['default'], 'avviata ' . $job['nome'] );

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

            // costruisco l'elenco giorni partendo da mese e anno
            $giorni = array();

            for( $d = 1; $d <= 31; $d++ )
            {
                $time = mktime(12, 0, 0, $mese, $d, $anno);          
                if ( date( 'm', $time ) == $mese ) {   
                    $giorni[] = intval( date( 'd' , $time ) );
                }
            }

            logWrite( 'lavoro il contratto ' . $cid , 'cartellini', LOG_ERR );
            foreach( $giorni as $giorno ){

                $data = date( 'Y-m-d', strtotime("$anno-$mese-$giorno") );

                // log
               
                // numero da 1 a 7, se la funzione date restituisce 0 (domenica) setto 7 per uniformità con i giorni degli orari_contratti
			    $numgiorno = ( date( 'w', strtotime("$anno-$mese-$giorno") ) == 0 ) ? '7' : date( 'w', strtotime("$anno-$mese-$giorno") );
    
                logWrite( 'verifico il contratto ' . $cid.' per il  giorno  '.$data , 'cartellini', LOG_ERR );
                
                // check if contratto valido nel giorno in analisi
                $contratto = mysqlSelectRow(
                    $cf['mysql']['connection'], 
                    'SELECT * FROM contratti WHERE id = ? AND data_inizio_rapporto <= ? AND '.
                    '( data_fine_rapporto IS NULL AND ( data_fine IS NULL OR ( data_fine IS NOT NULL and data_fine >= ? ) ) )',
                    array( array( 's' => $cid ), array( 's' =>  $data ), array( 's' =>  $data ) )
                );

                if( !empty( $contratto ) && isset( $contratto['id'] ) ){
    
                    logWrite( 'il contratto ' . $cid . ' è valido nel giorno  '.$data , 'cartellini', LOG_ERR );
                    // verifico se la data corrente è nella tabella turni e ricavo il turno corrispondente
                    $turno = mysqlSelectValue(
                        $cf['mysql']['connection'], 
                        'SELECT turno FROM turni WHERE id_contratto = ? AND (data_inizio <= ? AND data_fine >= ?) ORDER BY id DESC LIMIT 1',
                        array( 
                            array( 's' => $cid ),
                            array( 's' => $data ),
                            array( 's' => $data )
                        )
                    );
    
                    // se ci sono turni devo considerare la tabella turni e vedere se la data corrente è in essi
                    if( empty( $turno ) ){
                        $turno = 1;
                    }
    
                    // ore previste da contratto per quel giorno
                  /*  $orecontratto = mysqlQuery(
                        $cf['mysql']['connection'], 
                        'SELECT tipologie_attivita_inps.id AS id_tipologia_inps, sum( time_to_sec( timediff( ora_fine, ora_inizio ) ) / 3600 ) as tot_ore FROM orari_contratti ' .
                        'LEFT JOIN costi_contratti ON orari_contratti.id_costo = costi_contratti.id ' .
                        'LEFT JOIN tipologie_attivita_inps ON costi_contratti.id_tipologia = tipologie_attivita_inps.id ' .
                        'WHERE orari_contratti.se_lavoro = 1 ' .
                        'AND orari_contratti.id_giorno = ? ' . 
                        'AND orari_contratti.id_contratto = ? AND orari_contratti.turno = ? '.
                        'GROUP BY tipologie_attivita_inps.id' ,
                        array(
                            array( 's' => $numgiorno ),
                            array( 's' => $cid ),
                            array( 's' => $turno )
                        )
                    );*/
                    $orecontratto = oreGiornaliereContratto( $contratto['id_anagrafica'], $data );

                    logWrite( 'il contratto ' . $cid.' per il giorno  '.$data.' prevede  '.count( $orecontratto ).' orari attivi ' , 'cartellini', LOG_ERR );

                    // genero i cartellini
                    if( !empty ( $orecontratto ) ){
                        foreach ( $orecontratto as $oc ){
                           
                            $cartellino = mysqlQuery( $cf['mysql']['connection'], 
                                'INSERT INTO cartellini ( id_anagrafica, data_attivita, id_tipologia_inps, ore_previste, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ? )  ',
                                array( 
                                    array( 's' => $contratto['id_anagrafica'] ), 
                                    array( 's' => $data ),
                                    array( 's' => 1 ), // tipologia inps ordinaria
                                    array( 's' => $orecontratto ),  
                                    array( 's' => time() ) ) 
                                );
                            
                        }
                    }
    
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
        //        slackTxtMsg( $cf['slack']['profile']['webhooks']['default'], 'completata ' . $job['nome'] );

            }

        }

    } else {

        // status
		$status['error'][] = 'questo job non può essere lanciato fuori dal cron';

        // output
        buildJson( $status );

    }
