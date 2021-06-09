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
        elseif( !isset(  $job['workspace']['mese'] ) || !isset(  $job['workspace']['anno'] ) ){
            $status['err'][] = 'mese o anno non settati';
        }
        else {

            // attività di avvio
            if( empty( $job['corrente'] ) ) {

                // rimuovo le eventuali righe di report già esistenti legate ad altri job
                $del = mysqlQuery(
                    $cf['mysql']['connection'],
                    'DELETE FROM __report_ore_operatori__ WHERE mese = ? AND anno = ?',
                    array(
                        array( 's' => $job['workspace']['mese'] ),
                        array( 's' => $job['workspace']['anno'] )
                    )
                );

                $status['result'] = mysqlSelectColumn(
					'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM anagrafica_view_static WHERE se_collaboratore = 1'
                );
                             
                // creo la lista delle anagrafiche da lavorare
                $job['workspace']['list'] = $status['result'];

                // segno il totale delle anagrafiche da lavorare
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

            // ricavo l'ID dell'anagrafica corrente
            $cid = $job['workspace']['list'][ $widx ];
			
			// logiche di calcolo e scrittura nel report
            $mese = $job['workspace']['mese'];
            $anno = $job['workspace']['anno'];

            // costruisco l'elenco giorni
            $giorni = array();

            for( $d=1; $d<=31; $d++ )
            {
                $time=mktime(12, 0, 0, $mese, $d, $anno);          
                if (date('m', $time) == $mese){  
                    $giorno = intval( date('d', $time) );
                    $giorni[] = date( 'Y-m-d', strtotime("$anno-$mese-$giorno") );
                }
            }

            // inizializzo il monte ore di quadratura da contratto
            $ore_contratto = 0;

            foreach( $giorni as $g ){
                $ore_contratto += oreGiornaliereContratto(  $cid, $g );
            }

            // calcolo le ore di attività di quadratura fatte
            $ore_fatte = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT sum(ore) FROM attivita AS a LEFT JOIN tipologie_attivita_inps AS t ON a.id_tipologia_inps = t.id '
                .'WHERE month(a.data_attivita) = ? AND year(a.data_attivita) = ? AND id_anagrafica = ? AND t.se_quadratura = 1',
                array(
                    array( 's' => $mese ),
                    array( 's' => $anno ),
                    array( 's' => $cid )
                )
            );

            // inserisco la riga nella tabella di report
            $insert = mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT INTO __report_ore_operatori__ (mese, anno, id_job, id_anagrafica, ore_contratto, ore_fatte) VALUES ( ?, ?, ?, ?, ?, ?)',
                array(
                    array( 's' => $mese ),
                    array( 's' => $anno ),
                    array( 's' => $job['id'] ),
                    array( 's' => $cid ),
                    array( 's' => str_replace(',', '.', $ore_contratto ) ),
                    array( 's' => ( empty( $ore_fatte ) ) ? 0 : str_replace(',', '.', $ore_fatte ) )
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
            if( $job['corrente'] == $job['totale'] ) {

                // scrivo la timestamp di completamento
                $jobs = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE job SET timestamp_completamento = ? WHERE id = ?',
                    array(
                    array( 's' => $time ),
                    array( 's' => $job['id'] )
                    )
                );

               // TODO: creazione del file csv qui?
				
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
