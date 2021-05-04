<?php

    /**
     * 
     *  
     * 
     */

    // inizializzo l'array del risultato
	$status = array();

    // inclusione di PHPExcel
	use PhpOffice\PhpSpreadsheet\Spreadsheet;
	use PhpOffice\PhpSpreadsheet\Reader\Xlsx;

    // lavoro lungo
    set_time_limit( 0 );

    // inclusione del framework
	if( defined( 'CRON_RUNNING' ) ) {

        // verifiche formali
        if( isset( $job['corrente'] ) && $job['corrente'] == $job['totale'] ) {

            // status
            $status['info'][] = 'iterazione a vuoto su job già completato';

        } elseif( empty( $job['workspace']['document'] ) ) {

            // status
            $status['error'][] = 'questo job richiede un documento per importare da esso i prodotti';

        } else {

            // attività di avvio
            if( empty( $job['corrente'] ) ) {

                $xls = \PhpOffice\PhpSpreadsheet\IOFactory::load( DIR_BASE . $job['workspace']['document'] );

		        // converto il foglio attivo in un array
			    $data = $xls->getActiveSheet()->toArray();
                
                  // controllo se sono presenti dati
			    if( is_array( $data ) && count( $data ) ) {

			    // prelevo l'intestazione
				$heads = array_shift( $data );

			    // TODO qui fare un if per controllare se heads contiene le etichette giuste

			    // valori di riferimento
				//$totale = count( $data );
				$corrente = ( ( empty( $job['corrente'] ) ) ? 0 : ( $job['corrente'] ) );
				$limite = min( array( $corrente + $job['iterazioni'], $totale ) );


                // chiamata API TeamSystem
                //$status['result'] = $data;

                // creo la lista di lavoro
                //$job['workspace']['list'] = $status['result'];

                // segno il totale delle cose da fare
                $job['totale'] = count( $data );

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
            } else {
                $status['error'][] = 'errore documento';
            }
                // mando un messaggio su Slack
                //slackTxtMsg( $cf['slack']['profile']['webhooks']['default'], 'avviata ' . $job['nome'] );

            } else {

                // incremento l'indice di lavoro
                $job['corrente']++;

            }

            // aggiusto l'indice di lavoro (gli array partono da zero)
            $widx = $job['corrente'] - 1;

            // ricavo l'ID della riga corrente
            $cid = $job['workspace']['list'][ $widx ];

            // lavoro del job
            /*    $status['result'] = restCall(
                    $cf['site']['url'].'task/anagrafica.import.api?__id__=' . $cid,
                    METHOD_GET,
                    NULL,
                    MIME_APPLICATION_JSON,
                    MIME_APPLICATION_JSON,
                    $status['status'],
                    NULL,
                    NULL,
                    NULL,
                    $status['error']
                );
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
                    array( 's' => $time ),
                    array( 's' => $job['id'] )
                    )
                );

                // mando un messaggio su Slack
               // slackTxtMsg( $cf['slack']['profile']['webhooks']['default'], 'completata ' . $job['nome'] );

            }

        }

    } else {

        // status
		$status['error'][] = 'questo job non può essere lanciato fuori dal cron';

        // output
        buildJson( $status );

    }
