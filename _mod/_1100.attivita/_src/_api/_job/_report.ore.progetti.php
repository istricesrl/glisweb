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
            $status['info'][] = 'iterazione a vuoto su job completato';

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
                    'DELETE FROM __report_ore_progetti__ WHERE mese = ? AND anno = ?',
                    array(
                        array( 's' => $job['workspace']['mese'] ),
                        array( 's' => $job['workspace']['anno'] )
                    )
                );

                $status['result'] = mysqlSelectColumn(
				    'id',
                    $cf['mysql']['connection'],
                    'SELECT id FROM progetti_produzione_view'
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

                // mando un messaggio su Slack
                slackTxtMsg( $cf['slack']['profile']['webhooks']['default'], 'avviata ' . $job['nome'] );

            } else {

                // incremento l'indice di lavoro
                $job['corrente']++;

            }

            // aggiusto l'indice di lavoro (gli array partono da zero)
            $widx = $job['corrente'] - 1;

            // ricavo l'ID del progetto corrente
            $cid = $job['workspace']['list'][ $widx ];
			
			// logiche di calcolo e scrittura nel report
            $mese = $job['workspace']['mese'];
            $anno = $job['workspace']['anno'];

            // calcolo le ore di todo peviste
            $ore_previste = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT sum(ore_previste) FROM todo WHERE month(data_programmazione) = ? AND year(data_programmazione) = ? AND id_progetto = ?',
                array(
                    array( 's' => $mese ),
                    array( 's' => $anno ),
                    array( 's' => $cid )
                )
            );

            // calcolo le ore di attività fatte
            $ore_fatte = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT sum(ore) FROM attivita AS a LEFT JOIN tipologie_attivita_inps AS t ON a.id_tipologia_inps = t.id '
                .'WHERE month(a.data_attivita) = ? AND year(a.data_attivita) = ? AND id_progetto = ? AND t.se_quadratura = 1',
                array(
                    array( 's' => $mese ),
                    array( 's' => $anno ),
                    array( 's' => $cid )
                )
            );

            // inserisco la riga nella tabella di report
            $insert = mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT INTO __report_ore_progetti__ (mese, anno, id_job, id_progetto, ore_previste, ore_fatte) VALUES ( ?, ?, ?, ?, ?, ?)',
                array(
                    array( 's' => $mese ),
                    array( 's' => $anno ),
                    array( 's' => $job['id'] ),
                    array( 's' => $cid ),
                    array( 's' => ( empty( $ore_previste ) ) ? 0 : str_replace(',', '.', $ore_previste ) ),
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
