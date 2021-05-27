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
	if( defined( 'CRON_RUNNING' ) ) {

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

                $status['result'] = mysqlSelectColumn(
					'id_anagrafica',
                    $cf['mysql']['connection'],
                   "SELECT a.id FROM anagrafica_view_static WHERE se_cliente = 1"
                );
                             
                // creo la lista dei clienti da lavorare
                $job['workspace']['list'] = $status['result'];

                // segno il totale dei clienti da lavorare
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

            // ricavo l'ID del cliente corrente
            $cid = $job['workspace']['list'][ $widx ];
			
			// logiche di calcolo e scrittura nel report
            $mese = $job['workspace']['mese'];
            $anno = $job['workspace']['anno'];

            // calcolo le ore di todo peviste
            $ore_previste = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT sum(ore_previste) FROM todo WHERE month(data_programmazione) = ? AND year(data_programmazione) = ? AND id_cliente = ?',
                array(
                    array( 's' => $mese ),
                    array( 's' => $anno ),
                    array( 's' => $cid )
                )
            );


            // calcolo le ore di attività fatte
            $ore_fatte = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT sum(ore) FROM attivita WHERE mese = ? AND anno = ? AND id_cliente = ?',
                array(
                    array( 's' => $mese ),
                    array( 's' => $anno ),
                    array( 's' => $cid )
                )
            );

            // inserisco la riga nella tabella di report
            $insert = mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT INTO __report_ore_clienti__ (mese, anno, id_job, id_cliente, ore_previste, ore_fatte) VALUES ( ?, ?, ?, ?, ?, ?)',
                array(
                    array( 's' => $mese ),
                    array( 's' => $anno ),
                    array( 's' => $job['id'] ),
                    array( 's' => $cid ),
                    array( 's' => $ore_previste ),
                    array( 's' => $ore_fatte )
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
